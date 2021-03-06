# Build

```sh
pacman -S entr
choosenim devel
# ^ because current stable (1.2.0) is broken:
# https://github.com/nim-lang/Nim/issues/13937
nimble install

# watch source files to rebuild + run server on change
git ls-files '*.nim' | entr -rc nim dev
```

See **config.nims** or run `nim help` for available convenient build tasks.


# Run

**Needs Chromium/Chrome browser** to be already installed.

## 1. Run web server & gui

First run the **orts(.exe)** executable, then:

On unix-likes:

```sh
chromium --app=http://localhost:8008/gui/ --window-size=500,220
```

Or on windows powershell:

```powershell
start chrome.exe '--app=http://localhost:8008/gui/ --window-size=500,230'
```

## 2. Configure OBS

Add "browser source", uncheck **Local file**, enter this URL:

```
http://localhost:8008/scoreboard/
```
