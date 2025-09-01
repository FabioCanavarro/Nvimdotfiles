-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "tundra",
  theme_toggle = { "catppuccin", "tundra" },
	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
  hl_override = {
    -- Catppuccin Red for breakpoints
    DapBreakpoint = { fg = "#eba0ac" },

    -- Catppuccin Blue for log points
    DapLogPoint = { fg = "#89b4fa" },

    -- Catppuccin Green for the stopped/current line highlight
    DapStopped = { fg = "#a6e3a1" },
  },
}

M.ui = {
  theme = "tundra",
  tabufline = {
    enabled= false
  }
}

return M
