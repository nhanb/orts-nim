component Player {
  style button {
    background: red;
    color: white;
    border: 0;
  }

  fun render : Html {
    <div class="player">
        <span class="plabel label">"Player 1"</span>

        <input class="pname"
               list="pname-list"
               type="text"
               id="p1name" />
        <datalist id="pname-list">
            <option value="Daigo Umehara"></option>
            <option value="Justin Wong"></option>
        </datalist>

        <input class="pcountry"
               list="pcountry-list"
               type="text"
               id="p1country" />
        <datalist id="pcountry-list">
            <option value="vn"></option>
            <option value="jp"></option>
        </datalist>

        <input class="pscore"
               type="number" />
        <span class="plabel label">"Player 1"</span>
    </div>
  }
}

component Main {
  style main {
    display: grid;
    grid-gap: 3px;
  }

  style match-desc {
    display: grid;
    grid-auto-flow: column;
    grid-template-columns: min-content auto;
    grid-gap: 3px;
  }

  fun render : Html {
    <div::main>
      <div::match-desc>
        <span class="label">"Match description"</span>
        <input id="match-description" type="text" />
      </div>

      <Player />
      <hr />
      <Player />

      <div class="action-buttons">
        <button>"▶ Apply"</button>
        <button>"✖ Discard"</button>
        <button>"↶ Reset scores"</button>
        <button>"⇄ Swap players"</button>
      </div>
    </div>
  }
}
