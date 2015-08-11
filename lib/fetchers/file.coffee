request = require 'request'
path = require 'path'
fs = require 'fs-extended'

class File
  constructor: (@options) ->

  fetch: (callback) ->
    if @options.path
      filename = path.basename(@options.url)
      filepath = "#{@options.path}/#{filename}"
      file = fs.createWriteStream(filepath)

      request(@options.url)
        .pipe(file)
        .on 'close', () ->
          callback()
    else
      request @options.url, (err, response, body) =>
        activeEditor = atom.workspace.getActiveTextEditor()

        if activeEditor.getText()
          promise = atom.workspace.open()
          promise.done (editor) =>
            editor.setText body
            @setDefaultPath(editor)
            callback()
        else
          activeEditor.setText body
          @setDefaultPath(activeEditor)
          callback()

  setDefaultPath: (editor) =>
    unless editor.getPath()
      saveOptions = editor.getSaveDialogOptions?() ? {}
      projectPath = atom.project.getPaths()[0]
      filename = path.basename(@options.url)
      saveOptions.defaultPath ?= "#{projectPath}/#{filename}"
      editor.getSaveDialogOptions = () ->
        saveOptions

module.exports = File