import os
import std/strformat
import strutils
import tables

var 
  home: string = getHomeDir()
  dotflow: string = fmt"{home}.config/dotflow"
  dotflow_file: string = fmt"{home}.config/dotflow/.dotflow"

# TODO: Create a file to save the old path so we can rebuild the dotfiles with dotflow
#[
  .dotflow =
  .zshrc:/home/artur/.zshrc
]#
proc store(src: string, dest: string) =
  let f = open(fmt"{dotflow_file}", fmAppend )
  f.writeLine(fmt"{src}:{dest}")

proc install() =
  var files = newSeq[Table[string, string]]()

  for line in lines dotflow_file:
    var paths = line.split(":")
    var path = initTable[string, string]()

    if "$HOME" in paths[0]:
      path["src"] = paths[0].replace("$HOME/", home)

    if "$HOME" in paths[1]:
      path["dest"] = paths[1].replace("$HOME/", home)
    
    if symlinkExists(path["dest"]):
      echo(fmt"[ERROR] Installation failed: {paths[1]} This file is already a symbolic link")
      return

    if not dirExists(path["src"]):
      if not fileExists(path["src"]):
        echo(fmt"[ERROR] {paths[0]} does not exists")
      else:
        discard
    
    files.add(path)
  
  for file in files:
    createSymlink(file["src"], file["dest"])

proc init()  =
  if fileExists(fmt"{home}/.config/dotflow"):
    echo("[WARNING] Dotflow already was initialized.")
    return

  createDir(fmt"{home}/.config/dotflow")
  
proc link(path: string) =

  if symlinkExists(path):
    echo("[ERROR] This file is already a symbolic link")
    return

  var isDir = dirExists(path)
  var tail = splitPath(path).tail
  var link_path = path 

  if isDir:
    moveDir(path, fmt"{dotflow}/{tail}")
  else:
    moveFile(path, fmt"{dotflow}/{tail}")

  createSymlink(fmt"{dotflow}/{tail}", path)

  if home in path:
    link_path = path.replace(home, "$HOME/")

  store(fmt"$HOME/.config/dotflow/{tail}", link_path)

  echo("[INFO] Done")


when isMainModule:
  import cligen
  dispatchMulti(
    [link, help={"path": "Add new file to be controlled."}],
    [install],
    [init]
  )
