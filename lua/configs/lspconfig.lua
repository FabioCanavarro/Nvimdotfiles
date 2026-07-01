-- STREAMING_CHUNK: LSP connection configuration
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

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

-- 2. Setup Python (basedpyright) with your custom inlay hints
setup_server("basedpyright", {
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
})
