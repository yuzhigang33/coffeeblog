'use strict'

express = require 'express'
Article = require './lib/article'
options = require './config'

app = express()

app.use '/assets', express.static(__dirname + '/assets')

app.get '/', Article.showList
app.get '/article', Article.showArticle
app.get '/new', Article.newArticle
app.post '/new', Article.addArticle
app.delete '/delete', Article.deleteArticle

app.listen options.port
console.log 'Server started. listened on ', options.port
