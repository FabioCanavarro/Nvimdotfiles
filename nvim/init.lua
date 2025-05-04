












-- Neovim config
if vim.g.neovide then
    local alpha = function()
      return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
    end
    vim.o.guifont = "FiraCode NF Retina:h11"
    vim.g.transparency = 0.85
    vim.g.neovide_opacity = 0.85
    vim.g.neovide_normal_opacity = 0.85
    vim.g.neovide_background_color = "#0f1117" .. alpha()
    vim.g.neovide_fullscreen = true
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_vfx_particle_density = 18
    vim.g.neovide_cursor_trail_size = 0.8
    vim.g.neovide_cursor_animation_length = 0.22
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5
    vim.g.neovide_refresh_rate = 240
    vim.g.neovide_refresh_rate_idle = 5

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

require("autosave").setup({
    enabled = true, -- Enable autosave when the plugin is loaded. Set to false to disable autosave, and only enable it when you run the :AutoSave toggle command.
    disable_inside_paths = {"./init.lua","../nvim-data/lazy/NvChad/lua/nvchad/plugins","../nvim-data/lazy/NvChad/lua/"}, -- A list of paths inside which autosave should be disabled. In Neovim, it is recommended to set this to {vim.fn.stdpath('config')} to disable autosave for files inside your Neovim configuration directory, so that Neovim doesn't reload whenever you type inside your configuration files.
})
vim.g.autosave_disable_inside_paths = {"./init.lua","../nvim-data/lazy/NvChad/lua/nvchad/plugins","../nvim-data/lazy/NvChad/lua/"}



vim.loader.enable()
vim.cmd("Autosave on")
vim.cmd("NvimTreeToggle")
vim.cmd("NvimTreeResize 20")
vim.cmd("q!")

vim.schedule(function()
require "mappings"
end)
vim.opt.shell = 'pwsh'
vim.opt.shellcmdflag = '-nologo -noprofile -ExecutionPolicy RemoteSigned -command'
vim.opt.shellxquote = ''

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
  },
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      -- you can also put keymaps in here
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}

require("hardtime").setup()


require("precognition").toggle()
vim.cmd("Precognition show")

require("time-tracker").setup({
  data_file = vim.fn.stdpath("data") .. "/time-tracker.db",
  tracking_events = { "BufEnter", "BufWinEnter", "CursorMoved", "CursorMovedI", "WinScrolled" },
  tracking_timeout_seconds = 5 * 60, -- 5 minutes
})

require("todo-comments").setup({})

require("tidy").setup({})

require("hover").setup {
    init = function()
        -- Require providers
        require("hover.providers.lsp")
        require('hover.providers.gh')
        -- require('hover.providers.gh_user')
        -- require('hover.providers.jira')
        -- require('hover.providers.dap')
        require('hover.providers.fold_preview')
        -- require('hover.providers.diagnostic')
        -- require('hover.providers.man')
        require('hover.providers.dictionary')
    end,
    preview_opts = {
        border = 'single'
    },
    -- Whether the contents of a currently open hover window should be moved
    -- to a :h preview-window when pressing the hover keymap.
    preview_window = false,
    title = true,
    mouse_providers = {
        'LSP'
    },
    mouse_delay = 1000
}

-- Setup keymaps
vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})

-- Mouse support
vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
vim.o.mousemoveevent = true


require("lspconfig").basedpyright.setup {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          callArgumentNames = true
        }
      }
    }
  }
}


vim.o.relativenumber = true

require('cord').setup {
  enabled = true,
  log_level = vim.log.levels.OFF,
  editor = {
    client = 'neovim',
    tooltip = 'The Superior Text Editor',
    icon = nil,
  },
  display = {
    theme = 'catppuccin',
    flavor = 'accent',
    swap_fields = false,
    swap_icons = false,
  },
  timestamp = {
    enabled = true,
    reset_on_idle = false,
    reset_on_change = false,
  },
  idle = {
    enabled = false,
    timeout = 300000,
    show_status = true,
    ignore_focus = false,
    unidle_on_focus = true,
    smart_idle = true,
    details = 'Idling',
    state = nil,
    tooltip = '💤',
    icon = nil,
  },
  text = {
    default = nil,
    workspace = function(opts) return 'Cooking in ' .. opts.workspace end,
    viewing = function(opts) return 'Viewing ' .. opts.filename end,
    editing = function(opts) return 'Editing ' .. opts.filename end,
    file_browser = function(opts) return 'Browsing files in ' .. opts.name end,
    plugin_manager = function(opts) return 'Managing plugins in ' .. opts.name end,
    lsp = function(opts) return 'Configuring LSP in ' .. opts.name end,
    docs = function(opts) return 'Reading ' .. opts.name end,
    vcs = function(opts) return 'Committing changes in ' .. opts.name end,
    notes = function(opts) return 'Taking notes in ' .. opts.name end,
    debug = function(opts) return 'Crying in ' .. opts.name end,
    test = function(opts) return 'Hoping that ' .. opts.name .. " will work!!" end,
    diagnostics = function(opts) return 'Crying in ' .. opts.name end,
    games = function(opts) return 'Playing ' .. opts.name end,
    terminal = "Terminaling so hard rn!!!",
    dashboard = 'Home',
  },
  buttons = {
     {
       label = 'View Repository',
       url = function(opts) return opts.repo_url end,
     },
  },
  assets = nil,
  variables = nil,
  hooks = {
    ready = nil,
    shutdown = nil,
    pre_activity = nil,
    post_activity = nil,
    idle_enter = nil,
    idle_leave = nil,
    workspace_change = nil,
  },
  plugins = nil,
  advanced = {
    plugin = {
      autocmds = true,
      cursor_update = 'on_hold',
      match_in_mappings = true,
    },
    server = {
      update = 'fetch',
      pipe_path = nil,
      executable_path = nil,
      timeout = 300000,
    },
    discord = {
      reconnect = {
        enabled = false,
        interval = 5000,
        initial = true,
      },
    },
    workspace = {
      root_markers = {
        '.git',
        '.hg',
        '.svn',
      },
      limit_to_cwd = false,
    },
  },
}
