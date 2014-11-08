http = require 'http'
sqlite3 = require('sqlite3').verbose()
swig = require 'swig'

options = require './config.json'

dbFile = options.db

## list all articles
listArticles = (req, res) ->
  titles = []

  db = new sqlite3.Database dbFile
  db.all "SELECT * FROM articles", (err, rows) ->
    # rows.forEach (row) ->
      # titles.push row.aid + ": " + row.title
    # articles = rows
    text = swig.renderFile 'views/index.html',
            articles: rows

    res.writeHead 200, {'Content-Type': 'text/html'}
    res.write text
    # res.end articles
    res.end()
    db.close()

onRequest = (req, res) ->

  if req.method is 'GET'
    switch  req.url
      when "/" then listArticles req, res
      when "/new_article" then res.end "new article"
      else res.end "not support router"

http.createServer(onRequest).listen options.port, options.host

console.log 'server started...'
