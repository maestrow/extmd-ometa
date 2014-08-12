require 'ometajs'
assert = require 'assert'
grammar = (require './extmdTest.ometajs').ExtmdTest


it 'escapeExceptions', ->
	assert.equal grammar.matchAll('&copy;', 'escapeExceptions'), '&copy;'

it 'oneOf', ->
	assert.equal grammar.matchAll('a', 'test_oneOf'), 'a'
	assert.equal grammar.matchAll('b', 'test_oneOf'), 'b'
	assert.equal grammar.matchAll('c', 'test_oneOf'), 'c'
	assert.throws -> grammar.matchAll('d', 'test_oneOf')