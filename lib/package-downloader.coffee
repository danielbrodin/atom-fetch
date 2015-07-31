request = require 'request'
AdmZip = require 'adm-zip'
fs = require 'fs-extended'

class PackageDownloader
  options: null

  constructor: (@options) ->

  fetch: (callback) ->
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
        callback()

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


module.exports = PackageDownloader