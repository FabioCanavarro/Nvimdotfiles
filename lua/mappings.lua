require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local dap = require("dap")
local dapui = require("dapui")

---@type ChadrcConfig
local M = {}


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

vim.keymap.set("n", "<C-t>", function()
  require("menu").open("default")
end, {desc = "Open context menu"})

vim.keymap.set("n", "<Leader>h", function()
  vim.cmd "FloatermToggle"
end, { desc = "FloatermToggle" })

vim.keymap.set("n", "<A-h>", function()
  vim.cmd "FloatermToggle"
end, { desc = "FloatermToggle" })

-- Debuggers
vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<Leader>du", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Open REPL" })
vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Terminate Session" })
vim.keymap.set("n", "<Leader>dui", dapui.toggle, { desc = "Toggle DAP UI" })

vim.keymap.set("n", "<Leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Set Conditional Breakpoint" })

vim.keymap.set("n", "<Leader>dd", function()
  vim.cmd.RustLsp('debuggables')
end, { desc = "Debug Rust Target" })

vim.keymap.set("n", "<Leader>dC", function()
  vim.cmd.RustLsp('debuggables!')
end, { desc = "Continue (Rerun) Last Debug" })
vim.keymap.set("n", "<Leader>tt", "<cmd>Telescope themes<cr>", { desc = "Toggle theme" })
