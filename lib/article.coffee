'use strict'

url = require 'url'
qs = require 'querystring'
swig = require 'swig'
sqlite3 = require 'sqlite3'
options = require '../config'
db = require './db'

sqlite3 = sqlite3.verbose()

class Article
  constructor: ->
    @articles = db.articles

  showList: (req, res) =>
    @articles.findAll()
      .then (result) =>
        articles = []
        for article in result
          articles.push article.dataValues
        text = swig.renderFile 'views/index.html',
                articles: articles
                admin: true # todo
        res.writeHead 200, {'Content-Type': 'text/html'}
        res.write text
        res.end()
      .catch (err) ->
        res.end err.toString()

  newArticle: (req, res) ->
    text = swig.renderFile 'views/new.html'
    res.writeHead 200, {'Content-Type': 'text/html'}
    res.write text
    res.end()

  showArticle: (req, res) =>
    item = url.parse req.url
    qry = qs.parse item.query
    aid = qry.aid
    @articles.findById aid
      .then (result) ->
        article = result.dataValues
        article.content = article.content.split '\r\n'
        text = swig.renderFile 'views/article.html',
                  article: article
          res.writeHead 200, {'Content-Type': 'text/html'}
          res.write text
          res.end()
      .catch (err) ->
        res.end err.toString()

  addArticle: (req, res) =>
    buffer = ""
    req.on 'data', (chunk) ->
      buffer += chunk.toString()

    req.on 'end', () =>
      body = qs.parse buffer
      title = body.title
      content = body.content
      @articles.create
        title: "#{title}"
        content: "#{content}"
        createdAt: Date()
      .then (result) ->
        article = result.dataValues
        article.content = article.content.split '\r\n'
        text = swig.renderFile 'views/article.html',
                article: article
        res.writeHead 200, {'Content-Type': 'text/html'}
        res.write text
        res.end()
      # db = new sqlite3.Database options.db
      # db.run "INSERT INTO articles values (NULL, '#{title}', '#{content}', datetime('now','localtime'))", (err) ->
      #   if err
      #     console.log err
      #     res.end 'error'
      #   db.all "SELECT * FROM articles", (err, rows) ->
      #     text = swig.renderFile 'views/index.html',
      #             articles: rows
      #     res.writeHead 200, {'Content-Type': 'text/html'}
      #     res.write text
      #     res.end()
      #     db.close()

  deleteArticle: (req, res) ->
    item = url.parse req.url
    aid = item.query.split('=')[1]

    db = new sqlite3.Database options.db
    db.run "DELETE FROM articles WHERE aid=#{aid}", (err) ->
      if err
        res.end 'error'
      db.all "SELECT * FROM articles", (err, rows) ->
        text = swig.renderFile 'views/index.html',
                articles: rows

        res.writeHead 200, {'Content-Type': 'text/html'}
        res.write text
        res.end()
        db.close()

module.exports = new Article()
