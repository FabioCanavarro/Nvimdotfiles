local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n",
  "<leader>a",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)
vim.keymap.set(
  "n", 
  "K",  function()
    vim.cmd.RustLsp({'hover', 'actions'})
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set("n", "Ke", vim.cmd.RustLsp('explainError'), { silent = true, buffer = bufnr })
vim.keymap.set("n", "Kr", vim.cmd.RustLsp({ 'renderDiagnostic'}), { silent = true, buffer = bufnr })
vim.keymap.set("n", "Kj", vim.cmd.RustLsp({ 'relatedDiagnostic'}), { silent = true, buffer = bufnr })

