{CompositeDisposable} = require 'atom'
ListView = null

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-text-editor',
      'fetch:file': =>
        @toggle('file')
      'fetch:package': =>
        @toggle('package')

    @subscriptions.add atom.commands.add '.tree-view .directory.selected',
      'fetch:file': (e) =>
        target = e.currentTarget
        path = target.getPath?()
        @toggle('file', path)
      'fetch:package': (e) =>
        target = e.currentTarget
        path = target.getPath?()
        @toggle('package', path)

    @setDefaults()

  deactivate: ->
    @subscriptions.dispose()

  toggle: (type, path=null) ->
    options =
      type: type
      data: @getList(type)
      path: path

    ListView ?= require './list-view'
    listView = new ListView()
    listView.toggle(options)

  getList: (type) ->
    type = "#{type}s"
    data = atom.config.get("fetch.#{type}")
    return data

  setDefaults: ->
    defaults =
      files:
        "jquery": "http://code.jquery.com/jquery.js"
      packages:
        "html5-boilerplate": "https://github.com/h5bp/html5-boilerplate/zipball/master"

    if not atom.config.get('fetch.files')
      atom.config.set 'fetch.files', defaults.files

    if not atom.config.get('fetch.packages')
      atom.config.set 'fetch.packages', defaults.packages