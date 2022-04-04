import os
import std/strformat

var 
  home: string = getHomeDir()
  dotflow: string = fmt"{home}.config/dotflow"

proc init()  =
  createDir(fmt"{home}/.config/dotflow")
  
proc link(path: string) =
  var isDir = dirExists(path)
  var tail = splitPath(path).tail
  
  echo isDir, tail, path

  if isDir:
    moveDir(path, fmt"{dotflow}/{tail}")
  else:
    moveFile(path, fmt"{dotflow}/{tail}")

  createSymlink(fmt"{dotflow}/{tail}", path)

  echo("[INFO] Done")

# TODO: Create a file to save the old path so we can rebuild the dotfiles with dotflow
#[
  .dotflow =
  .zshrc:/home/artur/.zshrc
]#

when isMainModule:
  import cligen
  dispatchMulti(
    [link, help={"path": "Add new file to be controlled."}],
    [init]
  )
