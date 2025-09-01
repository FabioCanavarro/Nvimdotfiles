require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local is_windows = vim.fn.has "win64" == 1 or vim.fn.has "win32" == 1 or vim.fn.has "win16" == 1

vim.o.relativenumber = true

if is_windows then
    vim.o.guifont = "FiraCode_NF_Retina,Hack_Nerd_Font_Mono:h11:h11"
end


if vim.g.neovide then
  vim.g.transparency = 0.65
  local alpha = function()
    return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
  end
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 0.8
  if is_windows then
    vim.g.neovide_fullscreen = true
  end
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

if is_windows then
  vim.opt.shell = "D:/Fabio/Tools/Git/usr/bin/zsh.exe"
  vim.opt.shellcmdflag = " -il -c"
  vim.opt.shellredir = ">%s 2>&1"
end

vim.o.mousemoveevent = false
vim.lsp.inlay_hint.enable(true)
vim.g.autosave_disable_inside_paths = { "../init.lua" }

vim.g.rustaceanvim = function()
  return {
    tools = {},
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
              mode = "prefix",
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
  }
end


