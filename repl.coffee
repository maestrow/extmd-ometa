require 'ometajs'

Extmd = require('./extmd.ometajs').Extmd
ExtmdTest = (require './test/extmdTest.ometajs').ExtmdTest
ShmakoWiki = require('./tmp/shmakowiki.ometajs').ShmakoWiki

matchAll = (grammar, text, rule) ->
  JSON.stringify grammar.matchAll(text, rule)