http = require 'http'
sqlite3 = require('sqlite3').verbose()

options = require './config.json'

dbFile = options.db

## list all articles
listArticles = (req, res) ->
  titles = []
  db = new sqlite3.Database dbFile
  db.all "SELECT * FROM articles", (err, rows) ->
    rows.forEach (row) ->
      titles.push row.aid + ": " + row.title

    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end titles.join '\n'
    db.close();


onRequest = (req, res) ->
  listArticles req, res

http.createServer(onRequest).listen options.port, options.host
console.log 'server started...'
