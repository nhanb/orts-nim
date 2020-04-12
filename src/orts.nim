import asynchttpserver, asyncdispatch, asyncfile, strutils, os, mimetypes, tables

const mimesTable = mimes.toTable


proc serveStaticFile(req: Request, filename: string) {.async.} =
  var file = openAsync(filename, fmRead)
  let data = await file.readAll()
  file.close()

  let fileExt = filename[filename.rfind('.') + 1 .. ^1]
  let mimetype = mimesTable.getOrDefault(fileExt)
  let headers = newHttpHeaders([("Content-Type", mimetype)])
  await req.respond(Http200, data, headers)


var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  var path = req.url.path[1..^1]

  if path.startswith("scoreboard/"):
    if path == "scoreboard/":
      path = "scoreboard/index.html"

    # TODO: letting unsanitized GET param dictate file read smells like a
    # security hazard but since this http server is only accessible locally it's
    # probably... fine?
    if fileExists(path):
      await req.serveStaticFile(path)
      return
    else:
      await req.respond(Http404, "Nothing to see here.")
      return

  else:
    await req.respond(Http404, "Nothing to see here.")

const port = 8008
echo("Starting server at port ", port)
waitFor server.serve(Port(port), cb, address="localhost")
