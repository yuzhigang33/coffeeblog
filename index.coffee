http = require 'http'
sqlite3 = require('sqlite3').verbose()

options = require './config.json'

dbFile = options.db

## list all articles
listArticles = (req, res) ->
  titles = []

  db = new sqlite3.Database dbFile
  db.all "SELECT * FROM articles", (err, rows) ->
    # rows.forEach (row) ->
      # titles.push row.aid + ": " + row.title
    articles = JSON.stringify rows
    
    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end articles
    # res.end titles.join '\n'
    db.close();

onRequest = (req, res) ->

  if req.method is 'GET'
    switch  req.url
      when "/" then listArticles req, res
      when "/new_article" then res.end "new article"
      else res.end "not support router"

http.createServer(onRequest).listen options.port, options.host

console.log 'server started...'
