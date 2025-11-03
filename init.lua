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

require("nvim-web-devicons").setup()


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
    workspace = 'Cooking in ${workspace} - ${diagnostics} problems',
    viewing = 'Viewing ${filename} - Listening to ${track_title} — ${track_artist}',
    editing = 'Editing ${filename} - Listening to ${track_title} — ${track_artist}',
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
    terminal = "Please kill me...",
    dashboard = "Home??",
  },
  buttons = {
    {
      label = function(opts)
            return opts.repo_url and 'View Repository'
        end,
      url = function(opts)
            return opts.repo_url
        end
    },
  },
  assets = nil,
  variables = true,
  hooks = {
    ready = nil,
    shutdown = nil,
    pre_activity = nil,
    post_activity = nil,
    idle_enter = nil,
    idle_leave = nil,
    workspace_change = nil,
  },
  plugins = {
    ['cord.plugins.diagnostics'] = {
      -- Enable AND configure diagnostics plugin
      scope = 'workspace', -- Set scope to 'workspace' instead of default 'buffer'
      severity = { min = vim.diagnostic.severity.ERROR }, -- Show warnings and above
      override = false
    },
    ['cord.plugins.lastfm'] = {
      interval = 5000,
      max_retries = 3,
      override = false
    }
  },
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
        enabled = true,
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

require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
    },
    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    auto_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        which_key = true,
        barbar = true,
        beacon = true,
        diffview = true,
        gitgraph = true

        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
    highlight_overrides = {
        all = function(colors)
            return {
                NvimTreeNormal = { fg = colors.none },
                CmpBorder = { fg = "#3e4145" },
            }
        end,
        latte = function(latte)
            return {
                Normal = { fg = latte.base },
            }
        end,
        frappe = function(frappe)
            return {
                ["@comment"] = { fg = frappe.surface2, style = { "italic" } },
            }
        end,
        macchiato = function(macchiato)
            return {
                LineNr = { fg = macchiato.overlay1 },
            }
        end,
        mocha = function(mocha)
            return {
                Comment = { fg = mocha.mauve },
            }
        end,
    },
})

vim.cmd.colorscheme "catppuccin"

require("barbar").setup({})
require("gitgraph").setup({})
require("barbar").setup({})
vim.cmd "Precognition show"
vim.cmd "ShowkeysToggle"
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>")

require("nvim-dap-virtual-text").setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
    all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, buf, stackframe, node, options)
    -- by default, strip out new line characters
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value:gsub("%s+", " ")
      else
        return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
      end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

    -- experimental features:
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}
