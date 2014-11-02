http = require 'http'

onRequest = (req, res)->
  res.writeHead 200, {'Content-Type': 'text/plain'}
  res.end 'Hello world'


http.createServer(onRequest).listen 8080, "0.0.0.0"
