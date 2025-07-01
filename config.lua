--- Configuration module for GridNav
-- Provides default values and config management functions
-- @module GridNav.config

local M = {}

--- Default configuration values
-- @field gridLineColor Color table for grid lines (RGBA values from 0-1)
-- @field gridBorderColor Color table for grid border (RGBA values from 0-1)
-- @field gridLineWidth Width of grid lines in pixels
-- @field gridBorderWidth Width of grid border in pixels
-- @field showMidpoint Boolean to toggle midpoint visibility
-- @field midpointSize Size of midpoint indicator in pixels
-- @field midpointShape Shape of midpoint indicator ("square" or "circle")
-- @field midpointFillColor Color table for midpoint fill (RGBA values from 0-1)
-- @field midpointStrokeColor Color table for midpoint stroke (RGBA values from 0-1)
-- @field midpointStrokeWidth Width of midpoint stroke in pixels
-- @field dimBackground Boolean to toggle background dimming
-- @field dimColor Color table for background dim (RGBA values from 0-1)
-- @field mainModifiers Table of modifiers for main hotkey
-- @field mainKey Key for main hotkey
-- @field moveDistance The percentage distance move the grid (values from 0-1)
-- @field cutAmount The percentage to cut the grid (values from 0-0.99)
-- @field showModalAlert Boolean to toggle modal alert messages
-- @field rightClickExitsGrid Boolean to close overlay on right click
M.defaults = {
  gridLineColor = {red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7},
  gridBorderColor = {red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7},
  gridLineWidth = 1,
  gridBorderWidth = 3,
  radius = 10,
  decorateCorners = false,
  showMidpoint = true,
  midpointSize = 10,
  midpointShape = "square", -- "square" or "circle"
  midpointFillColor = {red = 1, green = 1, blue = 1, alpha = 0.2},
  midpointStrokeColor = {red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7},
  midpointStrokeWidth = 0,
  dimBackground = true,
  dimColor = {red = 0, green = 0, blue = 0, alpha = 0.3},
  moveDistance = 1,
  cutAmount = 0.5,
  showModalAlert = false,
  rightClickExitsGrid = false,  -- When false, right-click keeps the grid active

  mainModifiers = {"cmd"},
  mainKey = ";",

  scrollEnabled = true,

  -- Add default key mappings
  keys = {
    -- Grid division
    cutLeft = "h",
    cutRight = "l",
    cutUp = "k",
    cutDown = "j",

    -- Grid movement
    moveLeft = {"shift", "h"},
    moveRight = {"shift", "l"},
    moveUp = {"shift", "k"},
    moveDown = {"shift", "j"},

    -- Mouse actions
    warpCursor = "w",
    leftClick = "space",
    rightClick = {"shift", "space"},
    doubleClick = {"ctrl", "space"},
    tripleClick = {{"ctrl", "shift"}, "space"},

    -- Special functions
    resizeToWindow = "t",
    centerAroundCursor = "c",

    -- Scroll actions (can be set to false to disable)
    scrollDown = {"cmd", "shift", "j"},
    scrollUp = {"cmd", "shift", "k"},
    scrollLeft = {"cmd", "shift", "h"},
    scrollRight = {"cmd", "shift", "l"}
  }
}

--- Update configuration with user values
-- @param spoon The GridNav spoon instance
-- @param userConfig Table containing user configuration values
function M.update(spoon, userConfig)
  -- Add validation
  if not spoon or not spoon.config then
    hs.logger.new('GridNav'):e('Invalid spoon in config.update')
    return
  end

  if type(userConfig) ~= "table" then
    hs.logger.new('GridNav'):e('userConfig must be a table')
    return
  end

  -- Extend the defaults with user config values
  for key, value in pairs(userConfig) do
    if key == "keys" and type(value) == "table" then
      -- Special handling for keys table - merge instead of replace
      spoon.config.keys = spoon.config.keys or {}
      for k, v in pairs(value) do
        spoon.config.keys[k] = v
      end
    elseif spoon.config[key] ~= nil then
      spoon.config[key] = value
    end
  end
end

--- Get a copy of the current config
-- @param spoon The GridNav spoon instance
-- @return table Copy of current configuration
function M.get(spoon)
  local configCopy = {}
  for k, v in pairs(spoon.config) do
    configCopy[k] = v
  end
  return configCopy
end

--- Validate the merged config table for GridNav
-- @param config Table to validate
-- @return true if valid, error message if not
function M.validate(config)
  assert(type(config) == "table", "Config must be a table")
  assert(type(config.gridLineColor) == "table", "gridLineColor must be a table")
  assert(type(config.gridBorderColor) == "table", "gridBorderColor must be a table")
  assert(type(config.gridLineWidth) == "number", "gridLineWidth must be a number")
  assert(type(config.gridBorderWidth) == "number", "gridBorderWidth must be a number")
  assert(type(config.radius) == "number", "radius must be a number")
  assert(type(config.decorateCorners) == "boolean", "decorateCorners must be a boolean")
  assert(type(config.showMidpoint) == "boolean", "showMidpoint must be a boolean")
  assert(type(config.midpointSize) == "number", "midpointSize must be a number")
  assert(type(config.midpointShape) == "string", "midpointShape must be a string")
  assert(type(config.midpointFillColor) == "table", "midpointFillColor must be a table")
  assert(type(config.midpointStrokeColor) == "table", "midpointStrokeColor must be a table")
  assert(type(config.midpointStrokeWidth) == "number", "midpointStrokeWidth must be a number")
  assert(type(config.dimBackground) == "boolean", "dimBackground must be a boolean")
  assert(type(config.dimColor) == "table", "dimColor must be a table")
  assert(type(config.moveDistance) == "number", "moveDistance must be a number")
  assert(type(config.cutAmount) == "number", "cutAmount must be a number")
  assert(type(config.showModalAlert) == "boolean", "showModalAlert must be a boolean")
  assert(type(config.rightClickExitsGrid) == "boolean", "rightClickExitsGrid must be a boolean")
  assert(type(config.mainModifiers) == "table", "mainModifiers must be a table")
  assert(type(config.mainKey) == "string", "mainKey must be a string")
  assert(type(config.scrollEnabled) == "boolean" or type(config.scrollEnabled) == "nil", "scrollEnabled must be a boolean or nil")
  assert(type(config.keys) == "table", "keys must be a table")

  local keys = config.keys
  local keyFields = {
    "cutLeft", "cutRight", "cutUp", "cutDown",
    "moveLeft", "moveRight", "moveUp", "moveDown",
    "warpCursor", "leftClick", "rightClick", "doubleClick", "tripleClick",
    "resizeToWindow", "centerAroundCursor",
    "scrollDown", "scrollUp", "scrollLeft", "scrollRight"
  }
  for _, k in ipairs(keyFields) do
    local v = keys[k]
    assert(v == nil or type(v) == "string" or type(v) == "table", "Key '"..k.."' must be string or table or nil")
  end

  return true
end

return M
