require 'ometajs'
assert = require 'assert'
extmd = (require '../extmd.ometajs').Extmd
extmdTest = (require './extmdTest.ometajs').ExtmdTest
grammar = null

equal = (rule, text, expected, g = grammar) ->
	assert.deepEqual g.matchAll(text, rule), expected

throws = (rule, text, g = grammar) ->
	assert.throws -> grammar.matchAll(text, rule)


describe 'Fundamentals', ->
  it 'oneOf', ->
  	grammar = extmdTest
  	equal 'test_oneOf', 'a', 'a'
  	equal 'test_oneOf', 'b', 'b'
  	equal 'test_oneOf', 'c', 'c'
  	throws 'test_oneOf', 'd'

  it 'between', ->
  	equal 'topInline', 
  		'a__b//**c**//__d', 
  		["a",["underline",["b",["italic",[["bold",["c"]]]]]],"d"],
  		extmd


describe 'link, img', ->
  before -> grammar = extmd

  describe 'link', ->
    it 'link', ->
      equal 'link', 
        '[The Example](http://example.com)', 
        ["link", "http://example.com", "The Example"]
    it 'link as rawlink', ->
      equal 'link', 
        'http://a+*/-_<> until space', 
        ["link","http://a+*/-_<>"]
    it 'link is part of inline, bolded', ->
      equal 'topInline', 
        'aaa**bbb http://x**y**z ccc**',
        ["aaa",["bold",["bbb ",["link","http://x**y**z"]," ccc"]]]

  describe 'img', ->
    it 'img', ->
      equal 'img',
        '![the title](https://asd.gif)',
        ["img","https://asd.gif","the title"]
    it 'img as rawImg', ->
      equal 'rawImg',
        'http://qwe.jpg ',
        'http://qwe.jpg'
    it 'img as part of inline, bolded', ->
      equal 'topInline',
        'aaa**bbb http://x**y**z.jpg ccc**',
        ["aaa",["bold",["bbb ",["img","http://x**y**z.jpg"]," ccc"]]]


describe 'inline', ->
  before -> grammar = extmd

  it 'inlinecode', ->
    equal 'topInline',
      'aaa**text1`xx **y** zz`text2**bbb',
      ["aaa",["bold",["text1",["inlinecode","xx **y** zz"],"text2"]],"bbb"]

describe 'header', ->
  before -> grammar = extmd
  it 'header with bold fragment', ->
    equal 'header',
      "## a**s**d\nqwe",
      ["header",2,["a",["bold",["s"]],"d"]]
  it 'should fail if starts not in beginning of the line', ->
    throws 'header', ' ## asd'
  it 'should be processed in top', ->
    equal 'top',
      " ## aaa //bbb//ccc\n\n### XXX\nYY",
      [["p",[" ## aaa ",["italic",["bbb"]],"ccc"]],["header",3,["XXX"]],["p",["YY"]]]

describe 'lists', ->
  before -> grammar = extmd
  it 'topList', ->
    equal 'topList',
      "* aaa\n* bbb\n  * ccc"
      ["list",[["li",["aaa"]],["li",["bbb",["list",[["li",["ccc"]]]]]]]]

describe 'paragraph', ->
  before -> grammar = extmd
  it 'one line', -> 
    equal 'paragraph', '123', ["p",["123"]]
  it 'line and emptylines', -> 
    equal 'paragraph', '123   \n   \n   ', ["p",["123"]]
  it 'a few paragraphs', ->
    equal 'top',
      "aaa   \naa\n\nbbb",
      [["p",["aaa   \naa"]],["p",["bbb"]]]
  it 'Before header must be at least one empty line', ->
    equal 'top',
      "aaa\n### bbb",
      [["p",["aaa\n### bbb"]]]

describe 'blockquote', ->
  before -> grammar = extmd
  it 'one line', -> 
    equal 'blockquote', '> 123', ["blockquote",["123"]]
  it 'line and emptylines', -> 
    equal 'blockquote', '> 123   \n   \n   ', ["blockquote",["123"]]
  it 'a few blockquotes', ->
    equal 'top',
      "> aaa   \naa\n\n> bbb",
      [["blockquote",["aaa   \naa"]],["blockquote",["bbb"]]]
  it 'Before header must be at least one empty line', ->
    equal 'top',
      "> aaa\n### bbb",
      [["blockquote",["aaa\n### bbb"]]]
