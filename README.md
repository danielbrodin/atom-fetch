# Fetch

A package for downloading files and packages (`.zip`) directly into your project.

Fetch have only been tested on a Mac with Yosemite, so please let me know how it works out on Windows.

## Usage
Right-click a folder in the tree-view and pick `Fetch file` or `Fetch package`, then pick the source and it will be downloaded and added to that folder.

Using `Fetch: file` from the command palette will add the contents of the file to the current editor if it's empty, or otherwise open a new file.

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