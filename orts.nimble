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
requires "karax >= 1.1.1"


# Build tasks, basically used as cross-platform makefile

task orts, "Compile orts binary":
  exec("nim c -o:bin/orts src/orts.nim")

task gui, "Compile js gui":
  exec("nim js -o:gui/index.js src/gui.nim")

task clean, "Clean up built artifacts":
  exec("rm -rf bin/* gui/index.js")
  #TODO implement Windows version too
