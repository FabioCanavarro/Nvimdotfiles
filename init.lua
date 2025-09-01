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

require("autosave").setup {
  enabled = true,
  disable_inside_paths = { "./init.lua", "./" },
}

vim.loader.enable()

vim.schedule(function()
  require "mappings"
end)

require("hardtime").setup()

require("precognition").toggle()

require("time-tracker").setup {
  data_file = vim.fn.stdpath "data" .. "/time-tracker.db",
  tracking_events = { "BufEnter", "BufWinEnter", "CursorMoved", "CursorMovedI", "WinScrolled" },
  tracking_timeout_seconds = 5 * 60, -- 5 minutes
}

require("todo-comments").setup {}

require("lspconfig").basedpyright.setup {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          callArgumentNames = true,
        },
      },
    },
  },
}

require("cord").setup {
  enabled = true,
  log_level = vim.log.levels.OFF,
  editor = {
    client = "neovim",
    tooltip = "The Superior Text Editor",
    icon = nil,
  },
  display = {
    theme = "catppuccin",
    flavor = "accent",
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
    details = "Idling",
    state = nil,
    tooltip = "💤",
    icon = nil,
  },
  text = {
    default = nil,
    workspace = function(opts)
      return "Cooking in " .. opts.workspace
    end,
    viewing = function(opts)
      return "Viewing " .. opts.filename
    end,
    editing = function(opts)
      return "Editing " .. opts.filename
    end,
    file_browser = function(opts)
      return "Browsing files in " .. opts.name
    end,
    plugin_manager = function(opts)
      return "Managing plugins in " .. opts.name
    end,
    lsp = function(opts)
      return "Configuring LSP in " .. opts.name
    end,
    docs = function(opts)
      return "Reading " .. opts.name
    end,
    vcs = function(opts)
      return "Committing changes in " .. opts.name
    end,
    notes = function(opts)
      return "Taking notes in " .. opts.name
    end,
    debug = function(opts)
      return "Crying in " .. opts.name
    end,
    test = function(opts)
      return "Hoping that " .. opts.name .. " will work!!"
    end,
    diagnostics = function(opts)
      return "Crying in " .. opts.name
    end,
    games = function(opts)
      return "Playing " .. opts.name
    end,
    terminal = "Terminaling so hard rn!!!",
    dashboard = "Home",
  },
  buttons = {
    {
      label = "View Repository",
      url = function(opts)
        return opts.repo_url
      end,
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
      cursor_update = "on_hold",
      match_in_mappings = true,
    },
    server = {
      update = "fetch",
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
        ".git",
        ".hg",
        ".svn",
      },
      limit_to_cwd = false,
    },
  },
}

require("neotest").setup {
  adapters = {
    require "rustaceanvim.neotest",
  },
}

require("noice").setup {}

require("key-analyzer").setup({
    -- Name of the command to use for the plugin
    command_name = "KeyAnalyzer", -- or nil to disable the command

    -- Customize the highlight groups
    highlights = {
        bracket_used = "KeyAnalyzerBracketUsed",
        letter_used = "KeyAnalyzerLetterUsed",
        bracket_unused = "KeyAnalyzerBracketUnused",
        letter_unused = "KeyAnalyzerLetterUnused",
        promo_highlight = "KeyAnalyzerPromo",

        -- Set to false if you want to define highlights manually
        define_default_highlights = true,
    },

    -- Keyboard layout to use
    -- Available options are: qwerty, colemak, colemak-dh, azerty, qwertz, dvorak
    layout = "qwerty",

    promotion = false,
})

require("floaterm").setup( {
    border = false,
    size = { h = 60, w = 70 },

    mappings = { sidebar = nil, term = nil},

    terminals = {
      { name = "Terminal", cmd = "neofetch" },
    },
})


vim.cmd "NvimTreeResize 20"
vim.cmd "NvimTreeToggle"
vim.cmd "Precognition show"
vim.cmd "ShowkeysToggle"
