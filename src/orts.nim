import asynchttpserver, asyncdispatch, asyncfile, strutils, os, mimetypes, tables, json
import rpc

const mimesTable = mimes.toTable

proc handleApi(req: Request) {.async.} =
  # Only allow POST method
  if req.reqMethod != HttpPost:
    await req.respond(Http405, "API only accepts POST requests.")
    return

  # Parse JSON
  var payload: JsonNode
  try:
    payload = parseJson(req.body)
  except JsonParsingError:
    await req.respond(Http400, "Malformed JSON.")
    return

  # Unmarshall RPC object
  var rpc: Rpc
  try:
    rpc = payload.to(Rpc)
  except ValueError:
    await req.respond(Http400, "Incorrect RPC signature.")
    return

  # Voila, type checked rpc!

  let headers = newHttpHeaders([("Content-Type", "application/json")])
  case rpc.kind
  of Apply:
    var file = openAsync("scoreboard/state.json", fmReadWrite)
    await file.write(rpc.newState)
    file.close()
    await req.respond(Http200, "", headers)


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

  if path.startswith("scoreboard/") or path.startswith("gui/"):
    if path == "scoreboard/" or path == "gui/":
      path &= "index.html"

    # TODO: letting unsanitized GET param dictate file read smells like a
    # security hazard but since this http server is only accessible locally it's
    # probably... fine?
    if fileExists(path):
      await req.serveStaticFile(path)
      return
    else:
      await req.respond(Http404, "Nothing to see here.")
      return

  elif path == "api":
    await handleApi(req)
    return

  else:
    await req.respond(Http404, "Nothing to see here.")

const port = 8008
echo("Starting server at port ", port)
waitFor server.serve(Port(port), cb, address="localhost")
