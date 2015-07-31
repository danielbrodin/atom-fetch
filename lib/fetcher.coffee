{Emitter} = require 'atom'

FileDownloader = null
PackageDownloader = null

class Fetcher
  options: null

  constructor: (@options) ->
    @emitter = new Emitter

  fetch: ->
    switch @options.type
      when 'file'
        FileDownloader ?= require './file-downloader'
        fileDownloader = new FileDownloader(@options)
        fileDownloader.fetch () =>
          @emitter.emit 'done'

      when 'package'
        PackageDownloader ?= require './package-downloader'
        packageDownloader = new PackageDownloader(@options)
        packageDownloader.fetch () =>
          @emitter.emit 'done'

  onDidFinish: (callback)->
    @emitter.on 'done', callback


module.exports = Fetcher