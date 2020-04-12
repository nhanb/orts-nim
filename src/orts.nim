import asynchttpserver, asyncdispatch

var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  await req.respond(Http200, "Hello World")

const port = 8008
echo("Starting server at port ", port)
waitFor server.serve(Port(port), cb, address="localhost")
