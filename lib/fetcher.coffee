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

    atom.notifications.addInfo "Fetching #{@options.title}..."

    method.fetch () ->
      atom.notifications.addSuccess "Done fetching #{@options.title}"

  onDidFinish: (callback)->
    @emitter.on 'done', callback


module.exports = Fetcher