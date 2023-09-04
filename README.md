# Halfsee.spoon

Right/left/full window tiling plugin for MacOS (similar to Windows 7+ window snapping) plugin for Hammerspoon.

## Installing

Download a [released Halfsee.spoon.zip](https://github.com/gorjusborg/halfsee.spoon/releases/latest) (or build one from source) and extract it to your `~/.hammerspoon/Spoons/` directory, for example installing Halfsee v1.0.0:

```bash
wget github.com/gorjusborg/Halfsee.spoon/releases/tag/v1.0.0/Halfsee.spoon.zip
unzip -d ~/.hammerspoon/Spoons/ Halfsee.spoon.zip
```

### Configuration

After installing the spoon, you'll need to add the following to your `~/.hammerspoon/init.lua` config to map it to the keys you want:

```lua
local Halfsee = hs.loadSpoon("Halfsee")

Halfsee:bindHotKeys({
  moveWinLeft={{"cmd"}, "Left"},
  moveWinRight={{"cmd"}, "Right"},
  maximizeWin={{"cmd"}, "Up"},
  restoreWin={{"cmd"}, "Down"}
})
```

After updating your `.hammerspoon/init.lua`, reload hammerspoon.

