request = require 'request'
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
      request @options.url, (err, response, body) ->
        activeEditor = atom.workspace.getActiveTextEditor()

        if activeEditor.getText()
          promise = atom.workspace.open()
          promise.done (editor) ->
            editor.setText body
            callback()
        else
          activeEditor.setText body
          callback()

module.exports = File