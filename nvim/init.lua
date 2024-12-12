














-- Neovim config
if vim.g.neovide then
    vim.o.guifont = "Hack Nerd Font:h11" -- text below applies for VimScript
    -- Helper function for transparency formatting
    local alpha = function()
      return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
    end
    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    vim.g.neovide_transparency = 0.85
    vim.g.transparency = 0.85
    vim.g.neovide_background_color = "#0f1117" .. alpha()
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_refresh_rate = 240
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_fullscreen = true
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
end








vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
local repo = "https://github.com/folke/lazy.nvim.git"
vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
{
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
},

{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('andweeb/presence.nvim')
vim.call('plug#end')
-- The setup config table shows all available config options with their default values:
require("presence").setup({
    -- General options
    auto_update         = true,                       -- Update activity based on autocmd events (if false, map or manually execute :lua package.loaded.presence:update())
    neovim_image_text   = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to :lua package.loaded.presence:update(<filename>, true))
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table ({{ label = "<label>", url = "<url>" }, ...}, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at lua/presence/file_assets.lua for reference)
    show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when enable_line_number is set to true (either string or function(line_number: number, line_count: number): string)
})


require("autosave").setup({
    enabled = true, -- Enable autosave when the plugin is loaded. Set to false to disable autosave, and only enable it when you run the :AutoSave toggle command.
    disable_inside_paths = {}, -- A list of paths inside which autosave should be disabled. In Neovim, it is recommended to set this to {vim.fn.stdpath('config')} to disable autosave for files inside your Neovim configuration directory, so that Neovim doesn't reload whenever you type inside your configuration files.
})
vim.loader.enable()
vim.cmd("Autosave on")
vim.cmd("NvimTreeToggle")
vim.cmd("NvimTreeResize 20")
vim.cmd("PlugUpdate")
vim.cmd("q!")

require("aerial").setup({
-- optionally use on_attach to set keymaps when aerial has attached to a buffer
on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
vim.cmd("Autosave on")
require("autosave").setup({
    enabled = true, -- Enable autosave when the plugin is loaded. Set to false to disable autosave, and only enable it when you run the :AutoSave toggle command.
    disable_inside_paths = {}, -- A list of paths inside which autosave should be disabled. In Neovim, it is recommended to set this to {vim.fn.stdpath('config')} to disable autosave for files inside your Neovim configuration directory, so that Neovim doesn't reload whenever you type inside your configuration files.
})
vim.schedule(function()
require "mappings"
end)
vim.cmd("CondaActivate basev2")
vim.opt.shell = 'pwsh'
vim.opt.shellcmdflag = '-nologo -noprofile -ExecutionPolicy RemoteSigned -command'
vim.opt.shellxquote = ''
local neogit = require('neogit')
neogit.setup {}
require("autosave").setup({
    enabled = true, -- Enable autosave when the plugin is loaded. Set to false to disable autosave, and only enable it when you run the :AutoSave toggle command.
    disable_inside_paths = {"./init.lua","../nvim-data/lazy/NvChad/lua/nvchad/plugins","../nvim-data/lazy/NvChad/lua/"}, -- A list of paths inside which autosave should be disabled. In Neovim, it is recommended to set this to {vim.fn.stdpath('config')} to disable autosave for files inside your Neovim configuration directory, so that Neovim doesn't reload whenever you type inside your configuration files.
})
