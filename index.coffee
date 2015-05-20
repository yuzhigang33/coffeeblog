"use strict"

http = require 'http'
fs = require 'fs'
url = require 'url'
qs = require 'querystring'
Article = require './lib/article'
options = require './config'

onRequest = (req, res) ->
  pathname = url.parse(req.url).pathname
  if req.method is 'GET'
    switch  pathname
      when "/" then Article.showList req, res
      when "/article" then Article.showArticle req, res
      when "/new_article" then Article.newArticle req, res
      when "/delete" then Article.deleteArticle req, res
      else
        if /\.(css)$/.test(pathname)
          res.writeHead 200, {'Content-Type': 'text/css'}
          res.write(fs.readFileSync __dirname + pathname)
          res.end()
        else if /\.(js)$/.test(pathname)
          res.writeHead 200, {'Content-Type': 'text/javascript'}
          res.write(fs.readFileSync __dirname + pathname)
          res.end()
        else if /favicon.ico/.test(pathname)
          res.writeHead 200
          res.write(fs.readFileSync __dirname + '/assets/favicon.ico')
          res.end()
        else
          res.end '404'
  else if req.method is 'POST'
    switch pathname
      when "/new_article" then Article.addArticle req, res
      else res.end '404'

http.createServer(onRequest).listen options.port, options.host

console.log 'Server started. listened on ', options.port
