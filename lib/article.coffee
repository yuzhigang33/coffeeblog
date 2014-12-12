'use strict'

sqlite3 = require 'sqlite3'
option = require '../config'

sqlite3 = sqlite3.verbose()

class Article
  showList: ->
    db = new sqlite3.cached.Database options.db
    db.all "SELECT * FROM articles", (err, rows) ->
      text = swig.renderFile 'views/index.html',
              articles: rows
              admin: true
      res.writeHead 200, {'Content-Type': 'text/html'}
      res.write text
      res.end()
      db.close()

  newArticle = (req, res) ->
    text = swig.renderFile 'views/new.html'
    res.writeHead 200, {'Content-Type': 'text/html'}
    res.write text
    res.end()

  showArticle = (req, res) ->
    item = url.parse req.url
    aid = item.query.split('=')[1]

    db = new sqlite3.Database options.db
    db.get "SELECT * FROM articles where aid=#{aid}", (err, row) ->
      row.content = row.content.split '\r\n'
      text = swig.renderFile 'views/article.html',
              article: row
      res.writeHead 200, {'Content-Type': 'text/html'}
      res.write text
      res.end()
      db.close()

  addArticle = (req, res) ->
    buffer = ""
    req.on 'data', (chunk) ->
      buffer += chunk.toString()

    req.on 'end', () ->
      body = qs.parse buffer
      title = body.title
      content = body.content
      db = new sqlite3.Database options.db
      db.run "INSERT INTO articles values (NULL, '#{title}', '#{content}', datetime('now','localtime'))", (err) ->
        if err
          console.log err
          res.end 'error'
        db.all "SELECT * FROM articles", (err, rows) ->
          text = swig.renderFile 'views/index.html',
                  articles: rows
          res.writeHead 200, {'Content-Type': 'text/html'}
          res.write text
          res.end()
          db.close()

  deleteArticle = (req, res) ->
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

module.exports = Artilce
