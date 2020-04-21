import strformat, strutils

switch("hints", "off")
switch("outdir", "bin")

proc compile(backend, source, output, buildargs="") =
  let cmd = fmt"nim {backend} --hints:off {buildargs} -o:{output} src/{source}"
  echo("╔═", "═".repeat(cmd.len + 1), "╗")
  echo("║ ", cmd, " ║")
  echo("╚═", "═".repeat(cmd.len + 1), "╝")
  exec(cmd)

proc compileGui(release=false) =
  compile("js", "gui.nim", "gui/index.js", if release: "-d:release" else: "")

proc compileServer(release=false, run=false) =
  var args = ""
  if release: args &= " -d:release"
  if run: args &= " -r"
  compile("c", "orts.nim", "bin/orts", args)

task gui, "compile js gui":
  compileGui()

task server, "compile server":
  compileServer()

task dev, "compile everything & run devserver":
  compileGui()
  compileServer(run=true)

task release, "compile everything in release mode":
  compileGui(release=true)
  compileServer(release=true)
  if defined(linux):
    exec("ls -lha gui/*.js bin/*")

task clean, "clean up built artifacts":
  #TODO does this work on Windows too?
  exec("rm -rf bin/* gui/index.js")
