# Package

version       = "0.1.0"
author        = "nhanb"
description   = "Fighting game stream scoreboard overlay"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["orts"]
skipExt       = @["nim"]



# Dependencies

requires "nim >= 1.2.0"
requires "karax >= 1.1.2"


# Build tasks, basically used as poor man's cross-platform Makefile:

import strformat

proc compile(backend, source, output, buildargs="") =
  let cmd = fmt"nim {backend} --hints:off {buildargs} -o:{output} src/{source}"
  echo("╔═", "═".repeat(cmd.len + 1), "╗")
  echo("║ ", cmd, " ║")
  echo("╚═", "═".repeat(cmd.len + 1), "╝")
  exec(cmd)

proc compileGui(release=false) =
  compile("js", "gui.nim", "gui/index.js", if release: "-d:release" else: "")

proc compileServer(release=false) =
  compile("c", "orts.nim", "bin/orts", if release: "-d:release" else: "")

task gui, "compile js gui":
  compileGui()

task server, "compile server":
  compileServer()

task dev, "compile everything":
  exec("nimble gui")
  exec("nimble server")

task release, "compile everything in release mode":
  compileGui(release=true)
  compileServer(release=true)
  if defined(linux):
    exec("ls -lha gui/*.js bin/*")

task clean, "Clean up built artifacts":
  #TODO does this work on Windows too?
  exec("rm -rf bin/* gui/index.js")
