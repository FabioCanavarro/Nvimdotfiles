-- STREAMING_CHUNK: LSP connection configuration
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Prevent LSP hover and signature help floating windows from taking cursor focus
local orig_hover = vim.lsp.handlers["textDocument/hover"]
if orig_hover then
  vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
    config = vim.tbl_extend("force", config or {}, { focusable = false })
    return orig_hover(err, result, ctx, config)
  end
end

local orig_sig = vim.lsp.handlers["textDocument/signatureHelp"]
if orig_sig then
  vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    config = vim.tbl_extend("force", config or {}, { focusable = false })
    return orig_sig(err, result, ctx, config)
  end
end

local servers = {
  "html",
  "cssls",
  "clangd",
  "arduino_language_server",
}

-- A dynamic setup function that checks your Neovim version
local function setup_server(server_name, custom_opts)
  -- Merge NvChad's default UI capabilities with any custom settings you provide
  local opts = vim.tbl_deep_extend("force", {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }, custom_opts or {})

  if vim.fn.has "nvim-0.11" == 1 then
    -- Native Neovim 0.11+ API (Bypasses the deprecation warning)
    vim.lsp.config[server_name] = opts
    vim.lsp.enable(server_name)
  else
    -- Fallback for Neovim 0.10 and older
    lspconfig[server_name].setup(opts)
  end
end

-- 1. Setup the standard web and C++ servers
for _, lsp in ipairs(servers) do
  setup_server(lsp)
end

-- 2. Setup Python (basedpyright or pyright fallback)
local python_lsp = vim.fn.executable("basedpyright") == 1 and "basedpyright" or "pyright"
setup_server(python_lsp, {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          callArgumentNames = true,
        },
      },
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
})
