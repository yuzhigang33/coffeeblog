"use strict"

http = require 'http'
fs = require 'fs'
url = require 'url'
qs = require 'querystring'
sqlite3 = require('sqlite3').verbose()
swig = require 'swig'

options =
  host: "localhost"
  port: 8000
  db:   "blog.db"

## list all articles
listArticles = (req, res) ->
  db = new sqlite3.Database options.db
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


onRequest = (req, res) ->
  pathname = url.parse(req.url).pathname

  if req.method is 'GET'
    switch  pathname
      when "/" then listArticles req, res
      when "/article" then showArticle req, res
      when "/new_article" then newArticle req, res
      when "/delete" then deleteArticle req, res
      else
        if /\.(css)$/.test(pathname)
          res.writeHead 200, {'Content-Type': 'text/css'}
          res.write(fs.readFileSync __dirname + pathname)
          res.end()
        else if /\.(js)$/.test(pathname)
          res.writeHead 200, {'Content-Type': 'text/javascript'}
          res.write(fs.readFileSync __dirname + pathname)
          res.end()
        else res.end '404'
  else if req.method is 'POST'
    switch pathname
      when "/new_article" then addArticle req, res
      else res.end '404'

http.createServer(onRequest).listen options.port, options.host

console.log 'server started...'
