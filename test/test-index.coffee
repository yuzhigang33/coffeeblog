{expect}  = require 'chai'
Article   = require '../lib/article'

describe "JSCoverage tests", ->
    it "should un-chain if statements", ->
        instrumentor = new Article.showList
        expect(instrumentor.toString()).to.equal '[object Database]'
