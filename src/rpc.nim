type
  RpcKind* {.pure.} = enum
    Apply

  Rpc* = object
    case kind*: RpcKind
    of Apply: newState*: string
