require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<C-t>", function()
  require("nvchad.themes").open {}
end)

map("n", "<Leader>pi", function()
  -- Toggle the global inlay hint setting
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  -- Print a message to confirm the new state
  if vim.lsp.inlay_hint.is_enabled() then
    print "Inlay hints ENABLED"
  else
    print "Inlay hints DISABLED"
  end
end, { desc = "Toggle Inlay Hints" })

if vim.g.neovide then
  map("n", "<Leader>pf", function()
    if vim.g.neovide_fullscreen then
      vim.g.neovide_fullscreen = false
      print "FullScreen DISABLED"
    else
      vim.g.neovide_fullscreen = true
      print "FullScreen ENABLED"
    end
  end, { desc = "Toggle FullScreen" })
end

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format { async = true, lsp_format = "fallback", range = range }
end, { range = true })
