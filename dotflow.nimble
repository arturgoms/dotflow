# Package

version       = "0.2.0"
author        = "Artur Gomes"
description   = "Dotflow handle your dotfiles"
license       = "MIT"
srcDir        = "src"
bin           = @["dotflow"]


# Dependencies

requires "nim >= 1.6.0"
requires "cligen >= 1.5.0"

# Tasks

task d, "Debug Build":
  exec("nim c -o:bin/dotflow src/dotflow.nim")

task dr, "Debug Build":
  exec("nim c -r -o:bin/dotflow src/dotflow.nim")

task r, "Release Build":
  exec("nim c -d:release --opt:size --passL:-s -o:bin/dotflow src/dotflow.nim")

task rr, "Release Build and Run..":
  exec("nim c -d:release --opt:size --passL:-s -r -o:bin/dotflow src/dotflow.nim")

task fullDoc, "Create NimDoc with private Procss etc.":
  exec("nim doc --docInternal src/dotflow.nim")
