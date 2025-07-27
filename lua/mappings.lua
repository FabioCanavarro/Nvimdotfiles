require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n","<C-t>", function ()
  require("nvchad.themes").open( {

  })
end)


map('n', '<Leader>pi', function()
  -- Toggle the global inlay hint setting
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  -- Print a message to confirm the new state
  if vim.lsp.inlay_hint.is_enabled() then
    print("Inlay hints ENABLED")
  else
    print("Inlay hints DISABLED")
  end
end, { desc = 'Toggle Inlay Hints' })


