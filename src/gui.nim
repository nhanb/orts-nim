include karax / prelude
include karax / [kajax, jjson]
import karax / kdom

type k = kstring

proc createDom(data: RouterData): VNode =
  let currentRoute =
    if data.hashPart == k"": k"#"
    else: data.hashPart

  result = buildHtml(tdiv):
    tdiv(id=k"tab-body"):
        button: text "TODO"

setRenderer createDom
