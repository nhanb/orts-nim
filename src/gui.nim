import json
import karax / [kbase, karax, karaxdsl, vdom, jstrutils, kajax]
import rpc

type k = kstring

type Player = object
  name: kstring
  team: kstring
  country: kstring
  score: int

type State = object
  matchDescription: kstring
  player1: Player
  player2: Player


proc `$`(s: State): string =
  $(%*{
    "match_description": $s.matchDescription,
    "p1name": $s.player1.name,
    "p1country": $s.player1.country,
    "p1score": $s.player1.score,
    "p1team": $s.player1.team,
    "p2name": $s.player2.name,
    "p2country": $s.player2.country,
    "p2score": $s.player2.score,
    "p2team": $s.player2.team,
  })


var state = State(
  matchDescription: "EVO Grand Finals",
  player1: Player(
    name: "Daigo Umehara",
    team: "Team Japan",
    country: "jp",
    score: 0,
  ),
  player2: Player(
    name: "",
    team: "",
    country: "us",
    score: 1,
  ),
)

proc renderPlayer(num: kstring, p: var Player): VNode =
  let scoreId: kstring = "p" & num & "score"

  buildHtml(tdiv(class="player")):
    span(class="plabel label"): text "Player " & num
    input(
      class="pname",
      list="pname-list",
      value=p.name,
      id="p" & num & "name",
      onchange = proc (ev: Event, n: VNode) =
        p.name = n.value
    )
    datalist(id="pname-list"):
      option(value="Daigo Umehara")
      option(value="Justin Wong")

    input(
      class="pcountry",
      list="pcountry-list",
      id="p" & num & "country",
      value=p.country,
      onchange = proc (ev: Event, n: VNode) =
        p.country = n.value
    )
    datalist(id="pcountry-list"):
      option(value="vn")
      option(value="jp")

    input(
      class="pscore",
      `type`="number",
      value= $p.score,
      id=scoreId,
      onchange = proc (ev: Event, n: VNode) =
        p.score = parseInt(n.value)
    )

    span(class="tlabel label"): text "Team " & num
    input(
      class="tname",
      list="tname-list",
      value=p.team,
      onchange = proc (ev: Event, n: VNode) =
        p.team = n.value
    )
    datalist(id="tlabel-list"):
      option(value="Team Japan")
      option(value="Team US")

    button(
      class="win",
      onclick = proc (ev: Event, n: VNode) =
        p.score += 1
        # Weird kink: input text isn't reactive
        # https://github.com/pragmagic/karax/issues/61
        getVNodeById(scoreId).setInputText($p.score)
    ): text "▲ Win"


proc createDom(data: RouterData): VNode =
  result = buildHtml(tdiv(class="main")):

    tdiv(class="match-desc"):
      span(class="label"): text "Match description"
      input(id="match-description", value=state.matchDescription)

    hr()

    renderPlayer("1", state.player1)
    hr()
    renderPlayer("2", state.player2)

    tdiv(class="action-buttons"):
      button(
        onclick = proc (ev: Event; n: VNode) =
          let rpc = Rpc(
            kind: Apply,
            newState: $state
          )
          let payload = %*rpc
          ajaxPost(
            url = "/api",
            headers = [(k"Content-Type", k"application/json")],
            data = $payload,
            cont = proc (httpStatus: int, response: kstring) =
              echo(httpStatus)
              echo(response)
          )
      ): text "▶ Apply"
      button(): text "✖ Discard"
      button(): text "↶ Reset scores"
      button(): text "⇄ Swap players"


setRenderer createDom
