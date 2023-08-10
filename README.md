# Halfsee.spoon

Right/left/full window tiling plugin for Hammerspoon (a.k.a. a 'Spoon').

## Installing

Download a release Halfsee.zip (or build one from source) and extract it to
your `~/.hammerspoon/Spoons/` directory.

### Configuration

You'll need to add the following to your `~/.hammerspoon/init.lua` config:

```lua
local Halfsee = hs.loadSpoon("Halfsee")

Halfsee:bindHotKeys({
  moveWinLeft={{"cmd"}, "Left"},
  moveWinRight={{"cmd"}, "Right"},
  maximizeWin={{"cmd"}, "Up"},
  restoreWin={{"cmd"}, "Down"}
})
```

After adding that to your `init.lua`, reload hammerspoon.

