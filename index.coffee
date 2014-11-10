http = require 'http'
fs = require 'fs'
url = require 'url'
sqlite3 = require('sqlite3').verbose()
swig = require 'swig'

options = require './config.json'

dbFile = options.db

## list all articles
listArticles = (req, res) ->

  db = new sqlite3.Database dbFile
  db.all "SELECT * FROM articles", (err, rows) ->
    text = swig.renderFile 'views/index.html',
            articles: rows

    res.writeHead 200, {'Content-Type': 'text/html'}
    res.write text
    res.end()
    db.close()

showArticle = (req, res) ->
  item = url.parse req.url
  aid = item.query.split('=')[1]

  db = new sqlite3.Database dbFile
  db.get "SELECT * FROM articles where aid=#{aid}", (err, row) ->
    text = swig.renderFile 'views/article.html',
            article: row
    res.writeHead 200, {'Content-Type': 'text/html'}
    res.write text
    res.end()
    db.close()

addArticle = (req, res) ->
  db = new sqlite3.Database dbFile
  aid = '5'
  title = 'title 555'
  content = 'content 55555555555555555555555555555555'
  db.run "INSERT INTO articles values ('#{aid}', '#{title}', '#{content}', datetime('now','localtime'))", (err) ->
    if err
      console.log err, 'reeeeeeerrrrrr'
      res.end();
    res.writeHead 200, {'Content-Type': 'text/html'}
    res.end("insert success")
    db.close()

onRequest = (req, res) ->

  if req.method is 'GET'
    pathname = url.parse(req.url).pathname

    switch  pathname
      when "/" then listArticles req, res
      when "/article" then showArticle req, res
      when "/new_article" then addArticle req, res
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

http.createServer(onRequest).listen options.port, options.host

console.log 'server started...'
