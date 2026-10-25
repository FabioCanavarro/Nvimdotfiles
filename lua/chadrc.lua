-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",
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
  hl_add = {
    St_macro_recording = { fg = "#f38ba8", bold = true },
  },
}

M.ui = {
  theme = "catppuccin",
  tabufline = {
    enabled= false
  },
  statusline = {
    theme = "default",
    separator_style = "default",
    order = {
      "mode",
      "macro",
      "file",
      "git",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "file_stats",
      "cwd",
      "cursor"
    },
    modules = {
      macro = function()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        end
        return "%#St_macro_recording#   REC @" .. reg .. " "
      end,
      file_stats = function()
        local utils = require("nvchad.stl.utils")
        local buf = utils.stbufnr()
        local lines = vim.api.nvim_buf_line_count(buf)
        return string.format("%%#StText# %d lines ", lines)
      end,
    }
  }
}

return M
