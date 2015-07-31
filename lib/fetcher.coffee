{Emitter} = require 'atom'

File = require './fetchers/file'
Package = require './fetchers/package'

class Fetcher
  options: null

  constructor: (@options) ->
    @emitter = new Emitter

  fetch: ->
    switch @options.type
      when 'file'
        method = new File(@options)
      when 'package'
        method = new Package(@options)

    method.fetch () =>
      @emitter.emit 'done'

  onDidFinish: (callback)->
    @emitter.on 'done', callback


module.exports = Fetcher