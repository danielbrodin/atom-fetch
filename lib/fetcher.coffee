{Emitter} = require 'atom'
request = require 'request'
AdmZip = require 'adm-zip'
fs = require 'fs-extended'
os = require 'os'
path = require 'path'

class Fetcher
  options: null

  constructor: (@options) ->
    @emitter = new Emitter

  fetch: ->
    switch @options.type
      when 'file' then @getFile()
      when 'package' then @getPackage()

  getFile: ->
    if @options.path
      filename = path.basename(@options.url)
      filepath = "#{@options.path}/#{filename}"
      file = fs.createWriteStream(filepath)

      request(@options.url)
        .pipe(file)
        .on 'close', () =>
          @emitter.emit 'done'
    else
      request @options.url, (err, response, body) =>
        activeEditor = atom.workspace.getActiveTextEditor()

        if activeEditor.getText()
          promise = atom.workspace.open()
          promise.done (editor) =>
            editor.setText body
            @emitter.emit 'done'
        else
          activeEditor.setText body
          @emitter.emit 'done'

  getPackage: ->
    filename = @options.title.replace(' ', '_').toLowerCase()
    endPath = @options.path
    tmpFilepath = endPath
    tmpFile = "#{tmpFilepath}/#{filename}.zip"
    file = fs.createWriteStream(tmpFile)

    request(@options.url)
      .pipe(file)
      .on 'close', () =>
        zip = @unzip(tmpFile, tmpFilepath)
        files = zip.getEntries()
        oldDir = @moveFiles(files, endPath)
        @emitter.emit 'done'

  unzip: (zipfile, path) ->
    zip = new AdmZip(zipfile)
    zip.extractAllTo(path)
    fs.unlink(zipfile)
    return zip

  moveFiles: (files, path) ->
    index = 0
    unzippedDir = null
    dirs = []
    numberOfFiles = files.length

    for file in files
      entryName = file.entryName
      isDir = file.isDirectory
      fullPath = "#{path}/#{entryName}"

      if index is 0
        dirs.push fullPath
        unzippedDir = entryName
      else if isDir
        dirs.push fullPath
      else
        newName = entryName.replace(unzippedDir, '')
        fs.moveFileSync("#{path}/#{entryName}", "#{path}/#{newName}")

      index++

    @removeDirs dirs.reverse()
    return unzippedDir

  removeDirs: (dirs) ->
    for dir in dirs
      fs.rmdirSync dir

  onDidFinish: (callback)->
    @emitter.on 'done', callback


module.exports = Fetcher