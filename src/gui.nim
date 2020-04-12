include karax / prelude
include karax / [kajax, jjson]
import karax / kdom

type k = kstring

type Player = object
  name: kstring
  team: kstring
  country: kstring
  score: int

type State = object
  player1: Player
  player2: Player


var state = State(
  player1: Player(
    name: "Daigo Umehara",
    team: "Team Japan",
    country: "jp",
    score: 0,
  ),
  player2: Player(
    name: "Justin Wong",
    team: "Team US",
    country: "us",
    score: 1,
  ),
)

proc renderPlayer(num: kstring, p: var Player): VNode =
  let scoreId = "p" & num & "score"

  buildHtml(tdiv(class=k"player")):
    span(class="plabel"): text "Player " & num
    input(
      class="pname",
      list="pname-list",
      placeholder="Player Name",
      value=p.name,
      id="p" & num & "name",
    )
    datalist(id="pname-list"):
      option(value="Daigo Umehara")
      option(value="Justin Wong")

    input(
      class="pcountry",
      list="pcountry-list",
      placeholder="Country",
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
    )

    span(class="tlabel"): text "Team " & num
    input(class="tname", list="tname-list", placeholder="Team Name", value=p.team)
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
    renderPlayer("1", state.player1)
    renderPlayer("2", state.player2)


setRenderer createDom
