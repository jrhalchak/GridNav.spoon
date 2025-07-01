--- Keybinding module for GridNav
-- Manages keyboard shortcuts for grid navigation
-- @module GridNav.keybindings

local logic = require("logic")
local config = require("config")

local M = {}

--- Helper for conditional binding with/without alerts
-- @param spoon The GridNav spoon instance
-- @param modifiers Table of key modifiers
-- @param key String key to bind
-- @param message Alert message to display (if showModalAlert is true)
-- @param pressedfn Function to call when key is pressed
-- @param releasedfn Function to call when key is released (optional)
-- @param repeatfn Function to call when key repeats (optional)
-- @return nil
local function cbind(spoon, modifiers, key, message, pressedfn, releasedfn, repeatfn)
  if not spoon or not spoon.state or not spoon.state.gridNavModal then
    hs.logger.new('GridNav'):e('Invalid spoon state in cbind')
    return
  end

  if not key or type(pressedfn) ~= "function" then
    hs.logger.new('GridNav'):e('Invalid parameters in cbind')
    return
  end

  if spoon.config.showModalAlert then
    spoon.state.gridNavModal:bind(modifiers, key, message, pressedfn, releasedfn, repeatfn)
  else
    spoon.state.gridNavModal:bind(modifiers, key, pressedfn, releasedfn, repeatfn)
  end
end

--- Setup all keybindings
-- Initializes all keyboard shortcuts for the grid navigation
-- @param spoon The GridNav spoon instance
-- @return nil
function M.setup(spoon)
  -- Basic navigation
  cbind(spoon, {}, "escape", "Exit GridNav", function()
    logic.exitGridNavMode(spoon)
  end)

  local keys = spoon.config.keys or config.defaults.keys or {}

  -- Extract key definitions with defaults
  local function getKeyCombo(keysTable, configKey)
    local mapping = keysTable[configKey] or config.defaults.keys[configKey]
    if type(mapping) == "table" and #mapping == 2 then
      return mapping[1], mapping[2]
    elseif type(mapping) == "string" then
      return {}, mapping
    else
      return {}, nil
    end
  end

  local cutLeftMods, cutLeftKey = getKeyCombo(keys, "cutLeft")
  local cutRightMods, cutRightKey = getKeyCombo(keys, "cutRight")
  local cutUpMods, cutUpKey = getKeyCombo(keys, "cutUp")
  local cutDownMods, cutDownKey = getKeyCombo(keys, "cutDown")

  local moveLeftMods, moveLeftKey = getKeyCombo(keys, "moveLeft")
  local moveRightMods, moveRightKey = getKeyCombo(keys, "moveRight")
  local moveUpMods, moveUpKey = getKeyCombo(keys, "moveUp")
  local moveDownMods, moveDownKey = getKeyCombo(keys, "moveDown")

  local warpCursorMods, warpCursorKey = getKeyCombo(keys, "warpCursor")
  local leftClickMods, leftClickKey = getKeyCombo(keys, "leftClick")
  local rightClickMods, rightClickKey = getKeyCombo(keys, "rightClick")
  local doubleClickMods, doubleClickKey = getKeyCombo(keys, "doubleClick")
  local tripleClickMods, tripleClickKey = getKeyCombo(keys, "tripleClick")
  local resizeToWindowMods, resizeToWindowKey = getKeyCombo(keys, "resizeToWindow")
  local centerAroundCursorMods, centerAroundCursorKey = getKeyCombo(keys, "centerAroundCursor")

  -- Direction keys
  cbind(spoon, cutLeftMods, cutLeftKey, "Cut Left", function()
    logic.cutLeft(spoon)
  end)

  cbind(spoon, cutRightMods, cutRightKey, "Cut Right", function()
    logic.cutRight(spoon)
  end)

  cbind(spoon, cutUpMods, cutUpKey, "Cut Up", function()
    logic.cutUp(spoon)
  end)

  cbind(spoon, cutDownMods, cutDownKey, "Cut Down", function()
    logic.cutDown(spoon)
  end)

  -- Movement bindings
  cbind(spoon, moveLeftMods, moveLeftKey, "Move Left", function()
    logic.moveLeft(spoon)
  end)

  cbind(spoon, moveRightMods, moveRightKey, "Move Right", function()
    logic.moveRight(spoon)
  end)

  cbind(spoon, moveUpMods, moveUpKey, "Move Up", function()
    logic.moveUp(spoon)
  end)

  cbind(spoon, moveDownMods, moveDownKey, "Move Down", function()
    logic.moveDown(spoon)
  end)

  -- Mouse actions
  cbind(spoon, warpCursorMods, warpCursorKey, "Warp Cursor", function()
    logic.warpCursor(spoon)
  end)

  cbind(spoon, leftClickMods, leftClickKey, "Left Click", function()
    logic.leftClick(spoon)
  end)

  cbind(spoon, rightClickMods, rightClickKey, "Right Click", function()
    logic.rightClick(spoon)
  end)

  cbind(spoon, doubleClickMods, doubleClickKey, "Double Click", function()
    logic.doubleClick(spoon)
  end)

  cbind(spoon, tripleClickMods, tripleClickKey, "Triple Click", function()
    logic.tripleClick(spoon)
  end)

  -- Special functions
  cbind(spoon, resizeToWindowMods, resizeToWindowKey, "Resize to Window", function()
    logic.resizeToWindow(spoon)
  end)

  cbind(spoon, centerAroundCursorMods, centerAroundCursorKey, "Center Around Cursor", function()
    logic.centerAroundCursor(spoon)
  end)

  -- Scroll commands with configurable bindings
  local scrollEnabled = spoon.config.scrollEnabled ~= false -- Default to true if not specified

  if scrollEnabled then
    -- Extract scroll key configurations with defaults
    local scrollDownMods, scrollDownKey = getKeyCombo(keys, "scrollDown")
    local scrollUpMods, scrollUpKey = getKeyCombo(keys, "scrollUp")
    local scrollLeftMods, scrollLeftKey = getKeyCombo(keys, "scrollLeft")
    local scrollRightMods, scrollRightKey = getKeyCombo(keys, "scrollRight")

    -- Bind scroll commands
    cbind(spoon, scrollDownMods, scrollDownKey, "Scroll Down", function()
      logic.scrollDown()
    end)

    cbind(spoon, scrollUpMods, scrollUpKey, "Scroll Up", function()
      logic.scrollUp()
    end)

    cbind(spoon, scrollLeftMods, scrollLeftKey, "Scroll Left", function()
      logic.scrollLeft()
    end)

    cbind(spoon, scrollRightMods, scrollRightKey, "Scroll Right", function()
      logic.scrollRight()
    end)
  end
end

return M
