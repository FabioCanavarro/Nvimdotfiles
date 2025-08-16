require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

vim.o.relativenumber = true

if vim.g.neovide then
	vim.g.transparency = 0.65
    local alpha = function()
      return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
    end
    vim.o.guifont = "FiraCode NF Retina:h11"
    vim.g.neovide_opacity = 0.8
    vim.g.neovide_normal_opacity = 0.8
    vim.g.neovide_background_color = "#0f1117" .. alpha()
    vim.g.neovide_floating_blur_amount_x = 1.0
    vim.g.neovide_floating_blur_amount_y = 1.0
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_vfx_particle_density = 18
    vim.g.neovide_cursor_trail_size = 0.4
    vim.g.neovide_cursor_animation_length = 0.22
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5
    vim.g.neovide_refresh_rate = 240
end


vim.opt.shell = 'pwsh'
vim.opt.shellcmdflag = '-nologo -noprofile -ExecutionPolicy RemoteSigned -command'
vim.opt.shellxquote = ''
vim.o.mousemoveevent = false

vim.lsp.inlay_hint.enable(true)


vim.g.autosave_disable_inside_paths = {"./init.lua","../nvim-data/lazy/NvChad/lua/nvchad/plugins","../nvim-data/lazy/NvChad/lua/"}

vim.g.rustaceanvim = function()
  -- Update this path
  local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb'
  local this_os = vim.uv.os_uname().sysname;

  -- The path is different on Windows
  if this_os:find "Windows" then
    codelldb_path = extension_path .. "adapter\\codelldb.exe"
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  else
    -- The liblldb extension is .so for Linux and .dylib for MacOS
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
  end

  local cfg = require('rustaceanvim.config')
  return {
    tools = {
    },
    -- LSP configuration
    server = {
      on_attach = function(client, bufnr)
        -- you can also put keymaps in here
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
        inlayHints = {
          -- ENABLED: Shows the inferred type for variables (e.g., `let x = 42;` shows `x: i32`).
          typeHints = {
            enable = true,
            -- Whether to hide type hints for `let` statements that initialize to a closure.
            hideClosureInitialization = false,
            -- Whether to hide inlay type hints for constructors.
            hideNamedConstructor = false,
          },

          -- ENABLED: Shows the return type of each step in a method chain.
          chainingHints = {
            enable = true,
          },

          -- ENABLED: Shows parameter names at the function call site (e.g., `my_fn(/*name:*/ "value")`).
          parameterHints = {
            enable = true,
          },

          -- ENABLED: Shows what a closing brace `}` belongs to for long blocks.
          closingBraceHints = {
            enable = true,
            -- Minimum number of lines before the hint is shown.
            minLines = 25,
          },


          ---------------------------------------------------
          -- HINTS YOU HAVE DISABLED OR LEFT AS DEFAULT (OFF)
          ---------------------------------------------------

          -- DISABLED: Does not show inlay hints for binding modes like `ref` and `ref mut` in patterns.
          bindingModeHints = {
            enable = true,
          },

          -- DISABLED: Does not show the inferred return type of closures.
          closureReturnTypeHints = {
            enable = "always", -- Other options: "always", "with_block"
          },

          -- DISABLED: Does not show elided lifetimes (e.g., `'a`) in function signatures.
          lifetimeElisionHints = {
            enable = "always", -- Other options: "always", "skip_trivial"
            useParameterNames = true,
          },
          -- DEFAULT (Off): Does not show how closures capture variables (e.g., by `&`, `&mut`, or `move`).
          closureCaptureHints = {
            enable = true,
          },

          -- DEFAULT (Off): Does not show enum variant discriminant values (e.g., `MyEnum::Variant = 0`).
          discriminantHints = {
            enable = "always", -- Other options: "always", "fieldless"
          },

          expressionAdjustmentHints = {
            enable = "always", -- Other options: "always", "prefix", "postfix"
            hideOutsideUnsafe = false,
            mode = "prefix"
          },

          -- DEFAULT (Off): Does not show implicit `drop` calls.
          implicitDrops = {
            enable = true,
          },
          -- DEFAULT (Off): Does not show the implied `Sized` bound on generic parameters.
          implicitSizedBoundHints = {
            enable = false,
          },

          -- DEFAULT (Off): Does not show hints for generic type or lifetime parameter names at call sites.
          -- Only `const` generic hints are enabled by default.
          genericParameterHints = {
            const = { enable = true }, -- Default is true
            lifetime = { enable = true },
            type = { enable = false },
          },
          ---------------------------------------------------
          -- GENERAL HINT CONFIGURATION
          ---------------------------------------------------

          -- Sets the maximum length for any inlay hint.
          maxLength = 25,

          -- Whether to render colons for type hints (`: i32`) and parameter hints (`name:`).
          renderColons = true,
          -- Defines the notation style for closures in hints.
          closureStyle = "impl_fn", -- Other option: "fn_trait"
  	},

        },
      },
    },
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  }
end

