```sh
pacman -S entr
choosenim devel
# ^ because current stable (1.2) is broken:
# https://github.com/nim-lang/Nim/issues/13937
nimble install

git ls-files | entr -r nimble run orts
```

On unix-likes:

```sh
chromium --app=http://localhost:8008 --window-size=600,200
```

Or on windows:

```powershell
Start-Process chrome.exe --app=http://localhost:8008 --window-size=600,200
```
