{$$, SelectListView} = require 'atom-space-pen-views'
Fetcher = require './fetcher'

module.exports =
class ListView extends SelectListView
  activate: ->
    new ListView

  cancelled: ->
    @hide()

  confirmed: (item) ->
    @cancel()
    atom.notifications.addInfo "Fetching #{item.title}..."
    fetcher = new Fetcher(item)
    fetcher.fetch()
    fetcher.onDidFinish () ->
      atom.notifications.addSuccess "Done fetchin #{item.title}"

  toggle: (@options) ->
    if @panel?.isVisible()
      @hide()
    else
      @show()

  hide: ->
    @panel?.hide()

  show: () ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    items = []

    for key, url of @options.data
      item =
        title: key
        url: url
        type: @options.type
        path: @options.path
      items.push(item)

    @setItems(items)
    @focusFilterEditor()

  viewForItem: (item) ->
    $$ ->
      @li item.title