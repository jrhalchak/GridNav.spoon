--- Utility functions for GridNav configuration and math
-- @module GridNav.utils

local config = require("config")

local M = {}

--- Default action percentages for cut and move operations
-- @field actions Table containing default cut and move percentages
local actions = {
  cut = config.defaults.cutAmount,
  move = config.defaults.moveDistance
}

--- Validate and clamp a percentage value for cut or move actions
-- @param amount number The user-supplied percentage value
-- @param action string Either "cut" or "move"
-- @return number A valid percentage value for the action
function M.validateCutMovePercentage(amount, action)
  local isUnderMax = action == "move" and amount <= 1 or amount < 1
  local valid = amount and amount > 0 and isUnderMax

  return valid and amount or actions[action]
end

--- Calculate the remaining distance after applying a percentage cut
-- @param distance number The original distance
-- @param percent number The percentage to cut (0-1)
-- @return number The resulting distance after the cut
function M.cutPercent(distance, percent)
  return distance - (distance * percent)
end

return M
