return {
  -- Core Editing & Formatting
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "NvChad/nvterm", enabled = false },
  { "vuciv/golf", cmd = "Golf" },

  -- UI & Which-Key
  {
    "folke/which-key.nvim",
    keys = { '"', "'", "`", "c", "v", "g", "<leader>" },
    cmd = "WhichKey",
    config = function()
      dofile(vim.g.base46_cache .. "whichkey")
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>b", group = "Buffer sorting" },
        { "<leader>c", group = "Code/LSP" },
        { "<leader>d", group = "Debug/DAP" },
        { "<leader>g", group = "Git" },
        { "<leader>p", group = "Toggle preference" },
        { "<leader>w", group = "Window picking" },
        { "<leader>x", group = "Close buffer" },
        { "<leader>a", group = "Aerial outline" },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = false,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      cmdline = { view = "cmdline" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function(_, opts)
      require("noice").setup(opts)
      
      -- Custom shortcuts to scroll documentation/hover in Insert/Normal/Visual mode without focusing
      vim.keymap.set({"n", "i", "s"}, "<C-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<C-f>"
        end
      end, { silent = true, expr = true, desc = "Scroll Docs Down" })

      vim.keymap.set({"n", "i", "s"}, "<C-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<C-b>"
        end
      end, { silent = true, expr = true, desc = "Scroll Docs Up" })
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },

  -- Languages & Treesitter
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      pcall(function()
        dofile(vim.g.base46_cache .. "syntax")
        dofile(vim.g.base46_cache .. "treesitter")
      end)
      return {
        ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc", "rust", "toml", "markdown", "markdown_inline" },
        auto_install = true,
        rainbow = { enable = true, extended_mode = true },
        highlight = { enable = true, use_languagetree = true },
        indent = { enable = true },
      }
    end,
  },

  -- Diagnostics & Utilities
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      { "xx", "Trouble diagnostics toggle", desc = "Diagnostics" },
      { "xX", "Trouble diagnostics toggle filter.buf=0", desc = "Buffer Diagnostics" },
      { "cs", "Trouble symbols toggle focus=false", desc = "Symbols" },
      { "cl", "Trouble lsp toggle focus=false win.position=right", desc = "LSP" },
    },
  },
  { "m-demare/hlargs.nvim" },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.api.nvim_set_hl(0, "IblChar", { fg = "#45475a" })
      vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#b4befe" })
      require("ibl").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "brianhuster/autosave.nvim",
    event = "InsertEnter",
    opts = {
      enabled = true,
      disable_inside_paths = { "./init.lua", "./" },
    },
  },

  -- Session & Minimap
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      { "wr", "SessionSearch", desc = "Session search" },
      { "ws", "SessionSave", desc = "Save session" },
      { "wa", "SessionToggleAutoSave", desc = "Toggle autosave" },
    },
    opts = {
      auto_restore = true,
      suppressed_dirs = { "/", "../../../../../../nvim/" },
      session_lens = { load_on_setup = true, previewer = false },
    },
  },
  {
    "gorbit99/codewindow.nvim",
    event = "VeryLazy",
    config = function()
      local codewindow = require "codewindow"
      codewindow.setup {
        active_in_terminals = false,
        auto_enable = true,
        exclude_filetypes = { "help" },
        max_minimap_height = 20,
        max_lines = nil,
        minimap_width = 15,
        use_lsp = true,
        use_treesitter = true,
        use_git = true,
        width_multiplier = 4,
        z_index = 1,
        show_cursor = true,
        screen_bounds = "lines",
        window_border = "single",
        relative = "win",
        events = { "TextChanged", "InsertLeave", "DiagnosticChanged", "FileWritePost" },
      }
      codewindow.apply_default_keybinds()
    end,
  },

  -- Debugging & External Tools
  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    tag = "stable",
    config = function()
      require("crates").setup()
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "Cargo.toml",
        callback = function()
          vim.keymap.set("n", "K", function()
            if require("crates").popup_available() then
              require("crates").show_popup()
            else
              vim.lsp.buf.hover()
            end
          end, { buffer = true, desc = "Show Crates Popup" })
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    priority = 1000,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
          require("mason-nvim-dap").setup { ensure_installed = { "codelldb" } }
        end,
      },
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {
      display = { theme = "minecraft" },
    },
  },

  -- Gamification & Flow
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    opts = { showmode = false, cmdheight = 2 },
  },
  {
    "3rd/time-tracker.nvim",
    dependencies = { "3rd/sqlite.nvim" },
    event = "VeryLazy",
    opts = function()
      return { data_file = vim.fn.stdpath "data" .. "/time-tracker.db" }
    end,
  },

  -- Additional UI Fixes & Replacements
  {
    "romgrk/barbar.nvim",
    dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
    lazy = false,
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {},
    version = "^1.0.0",
  },
  {
    "isakbm/gitgraph.nvim",
    keys = {
      {
        "gl",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
    opts = {
      git_cmd = "git",
      symbols = { merge_commit = "M", commit = "*" },
      format = { timestamp = "%H:%M:%S %d-%m-%Y", fields = { "hash", "timestamp", "author", "branch_name", "tag" } },
    },
  },
  {
    "nvzone/showkeys",
    lazy = false,
    opts = { maxkeys = 5, position = "top-center" },
    config = function(_, opts)
      require("showkeys").setup(opts)
      vim.schedule(function()
        vim.cmd "ShowkeysToggle"
      end)
    end,
  },
  {
    "tris203/precognition.nvim",
    lazy = false,
    opts = {
      highlightColor = { link = "Precognition" },
      targetedMotionHighlightColor = { link = "PrecognitionTargeted" },
    },
    config = function(_, opts)
      require("precognition").setup(opts)
      vim.schedule(function()
        vim.cmd "Precognition show"
      end)
    end,
  },
  { "nvzone/menu", lazy = true },
  {
    "nvzone/floaterm",
    cmd = "FloatermToggle",
    opts = {},
  },
  {
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    opts = {},
  },

  -- The Master Theme Configuration
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        background = { light = "latte", dark = "mocha" },
        transparent_background = false,
        custom_highlights = function(colors)
          return {
            Precognition = { fg = colors.subtext0, style = { "italic" } },
            PrecognitionTargeted = { fg = colors.surface1, style = { "italic" } },
          }
        end,
        highlight_overrides = {
          all = function(colors)
            return {
              NvimTreeNormal = { fg = colors.none },
              CmpBorder = { fg = "#3e4145" },
            }
          end,
          mocha = function(mocha)
            return {
              Comment = { fg = mocha.mauve },
            }
          end,
        },
      }
    end,
  },

  -- Modern QoL & UI Enhancements
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "willothy/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          bo = {
            filetype = { "NvimTree", "neo-tree", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {},
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({})
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>ao", "<cmd>AerialToggle!<cr>", desc = "Toggle Aerial Outline" }
    }
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
      sign = { enabled = true },
      virtual_text = { enabled = true, text = " 💡 " },
    },
  },
}
