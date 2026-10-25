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

local standard_servers = {
  "html",
  "cssls",
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
    -- Native Neovim 0.11+ API (Merges with default config)
    vim.lsp.config(server_name, opts)
    vim.lsp.enable(server_name)
  else
    -- Fallback for Neovim 0.10 and older
    lspconfig[server_name].setup(opts)
  end
end

-- 1. Setup standard servers
for _, lsp in ipairs(standard_servers) do
  setup_server(lsp)
end

-- 2. Setup Clangd for C and C++
local clangd_capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
  offsetEncoding = { "utf-16" },
})

setup_server("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  capabilities = clangd_capabilities,
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    -- Enable inlay hints by default for C/C++ buffers
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})

-- Fallback source/header switcher command in case clangd_extensions is not active
if vim.fn.exists ":ClangdSwitchSourceHeader" ~= 2 then
  vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
    if not client then
      vim.notify("clangd LSP is not attached to this buffer", vim.log.levels.WARN)
      return
    end
    local params = { uri = vim.uri_from_bufnr(bufnr) }
    client:request("textDocument/switchSourceHeader", params, function(err, result)
      if err then
        vim.notify("Error switching source/header: " .. tostring(err), vim.log.levels.ERROR)
        return
      end
      if not result or result == "" then
        vim.notify("Corresponding header/source file not found", vim.log.levels.WARN)
        return
      end
      vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
  end, { desc = "Switch between C/C++ source and header file" })
end

-- 3. Setup Python (basedpyright or pyright fallback)
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
