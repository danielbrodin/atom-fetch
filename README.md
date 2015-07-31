# Fetch

A package for downloading files and packages (`.zip`) directly into your project, based on the Sublime Text package [Nettuts+ Fetch](http://code.tutsplus.com/articles/introducing-nettuts-fetch--net-23490).

Fetch have only been tested on a Mac with Yosemite, so please let me know how it works out on Windows.

Fetch is based on the Sublime Text package .

## Usage
### Tree view
Right-click on a folder in the tree view and pick the type you want to fetch and the source will be downloaded to that folder.

### Command palette
Using `Fetch: file` will add the contents of the file to the current editor if it's empty, or otherwise open a new file.

Using `Fetch: package` will download and add the contents of the package to the root folder of the project.

## Config
Open up `config.cson` and modify the `files` and `packages` settings
```
fetch:
  files:
    jquery: "http://code.jquery.com/jquery.js"
  packages:
    "html5-boilerplate": "https://github.com/h5bp/html5-boilerplate/zipball/master"
```

## Todo
- [ ] Add more default sources?
- [ ] Write tests