--- === Halfsee ===
---
--- Left/Right/Full-screen window tiling across monitors

local Halfsee={}
Halfsee.__index = Halfsee

-- Metadata
Halfsee.name = "Halfsee"
Halfsee.version = "1.0"
Halfsee.author = "gorjusborg"
Halfsee.license = "MIT - https://opensource.org/licences/MIT"

-- unit rects for right and left halves of screen
local leftHalfUnit = hs.geometry.rect(0, 0, 0.5, 1)
local rightHalfUnit = hs.geometry.rect(0.5, 0, 0.5, 1)

-- returns (n1 - n2) or nil if either is nil
local function safeDifference(n1, n2)
  if not n1 or not n2 then
    return nil
  else
    return n1 - n2
  end
end

-- returns abs(n1 - n2) or nil if either is nil
local function safeAbsDifference(n1, n2)
  local diff = safeDifference(n1, n2)
  if not diff then
    return nil
  else
    return math.abs(diff)
  end
end

-- compares the two rects and returns true if they are roughly equal,
-- based on the maximum numerical difference considered still equal (maxError)
--
-- this allows overlooking some rounding errors when converting between unit 
-- rects and screen rects
local function fuzzyRectEquals(r1, r2, maxError)
  local maxErr = (maxError == nil and 0.001) or maxError

  if safeAbsDifference(r1.x, r2.x) > maxErr then
    return false
  end
  if safeAbsDifference(r1.y, r2.y) > maxErr then
    return false
  end
  if safeAbsDifference(r1.w,r2.w) > maxErr then
    return false
  end
  if safeAbsDifference(r1.h, r2.h) > maxErr then
    return false
  end

  return true
end

function Halfsee:init()
  self.origUnitRects = {}
end

function Halfsee:bindHotKeys(mapping)
  local spec = {
    moveWinLeft = hs.fnutils.partial(self.moveWinLeft, self),
    moveWinRight = hs.fnutils.partial(self.moveWinRight, self),
    maximizeWin = hs.fnutils.partial(self.maximizeWin, self),
    restoreWin = hs.fnutils.partial(self.restoreWin, self),
  }
  hs.spoons.bindHotkeysToSpec(spec, mapping)
  return self
end

--- Halfsee:moveWinLeft()
--- Method
--- Move/size the focused window to fill the left half of the current screen, or if already in that position and there is another screen in that direction, move it to the right half of the next screen.
function Halfsee:moveWinLeft()
    local win = hs.window.focusedWindow()
    local id = win:id()
    local winFrame = win:frame()
    local screenFrame = win:screen():frame()

    if not self.origUnitRects[id] then
        self.origUnitRects[id] = winFrame:toUnitRect(screenFrame)
    end


    local winUnit = winFrame:toUnitRect(screenFrame)
    if fuzzyRectEquals(winUnit, leftHalfUnit) then
      local nextScreen = win:screen():toWest()
      if nextScreen then
        win:move(rightHalfUnit:fromUnitRect(nextScreen:frame()), nextScreen)
      end
    else
      win:move(leftHalfUnit:fromUnitRect(screenFrame))
    end
end

--- Halfsee:moveWinRight()
--- Method
--- Move/size the focused window to fill the right half of the current screen, or if already in that position and there is another screen in that direction, move it to the right half of the next screen.
function Halfsee:moveWinRight()
    local win = hs.window.focusedWindow()
    local id = win:id()
    local winFrame = win:frame()
    local screenFrame = win:screen():frame()

    if not self.origUnitRects[id] then
        self.origUnitRects[id] = winFrame:toUnitRect(screenFrame)
    end

    local winUnit = winFrame:toUnitRect(screenFrame)
    if fuzzyRectEquals(winUnit, rightHalfUnit) then
      local nextScreen = win:screen():toEast()
      if nextScreen then
        win:move(leftHalfUnit:fromUnitRect(nextScreen:frame()), nextScreen)
      end
    else
      win:move(rightHalfUnit:fromUnitRect(screenFrame))
    end
end

--- Halfsee:maximizeWin()
--- Method
---
--- Size the focused window to fill the current screen entirely.
function Halfsee:maximizeWin()
    local win = hs.window.focusedWindow()
    local id = win:id()
    local winFrame = win:frame()
    local screenFrame = win:screen():frame()

    if not self.origUnitRects[id] then
        self.origUnitRects[id] = winFrame:toUnitRect(screenFrame)
    end

    if not winFrame:equals(screenFrame) then
      win:move(screenFrame)
    end
end

--- Halfsee:restoreWin
--- Method
---
--- Size the focused window back to its original shape (before it was manipulated at all).
function Halfsee:restoreWin()
    local win = hs.window.focusedWindow()
    local id = win:id()
    local screenFrame = win:screen():frame()

    local origUnitRect = self.origUnitRects[id]
    if origUnitRect then
        win:move(origUnitRect:fromUnitRect(screenFrame))
    end
    self.origUnitRects[id] = nil
end

return Halfsee
