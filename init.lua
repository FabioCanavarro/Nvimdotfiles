-- ==============================================================================
-- 1. GLOBAL SETTINGS & WORKAROUNDS
-- ==============================================================================

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Disable all the annoying ding sounds
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.belloff = "all"

-- Cursorline
vim.opt.cursorline = true

-- Temporary workaround for barbar.nvim on Neovim 0.13 nightly
local _orig_autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_autocmd = function(events, opts)
  local intercepts_bms = false
  if type(events) == "string" and events == "BufModifiedSet" then
    events = "OptionSet"
    intercepts_bms = true
  elseif type(events) == "table" then
    for i, e in ipairs(events) do
      if e == "BufModifiedSet" then
        events[i] = "OptionSet"
        intercepts_bms = true
      end
    end
  end
  if intercepts_bms then
    opts = opts or {}
    opts.pattern = "modified"
  end
  return _orig_autocmd(events, opts)
end

-- ==============================================================================
-- 2. BOOTSTRAP LAZY.NVIM
-- ==============================================================================

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy" 

-- ==============================================================================
-- 3. LOAD PLUGINS & NVCHAD
-- ==============================================================================

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- ==============================================================================
-- 4. LOAD CORE THEMES, OPTIONS & MAPPINGS
-- ==============================================================================

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    dofile(vim.g.base46_cache .. "statusline")
  end,
})

-- Force statusline redraw on macro recording start/stop
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  callback = function()
    vim.cmd "redrawstatus"
  end,
})

require "options"
require "nvchad.autocmds"

vim.loader.enable()

-- Schedule mappings to load after UI stabilization
vim.schedule(function()
  require "mappings"
  vim.cmd "colorscheme catppuccin"
end)

