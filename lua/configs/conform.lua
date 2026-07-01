-- STREAMING_CHUNK: Conform formatter configuration
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Using ruff for Python since you installed it in Mason
    python = { "ruff_format" },
    -- Standard web formatters
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    -- C/C++ formatting via clang-format
    c = { "clang-format" },
    cpp = { "clang-format" },
    -- Rust is usually handled by rust-analyzer/rustaceanvim, but just in case
    rust = { "rustfmt" },
  },

  -- Uncomment this block if you want it to format every time you save a file
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
