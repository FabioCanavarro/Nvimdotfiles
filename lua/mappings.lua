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
vim.keymap.del({ "n", "t" }, "<A-v>")
vim.keymap.del({ "n", "t" }, "<A-h>")
vim.keymap.del({ "n", "t" }, "<A-i>")

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

vim.keymap.set({ "n", "t" }, "<C-t>", function()
  require("menu").open("default")
end, {desc = "Open context menu"})

vim.keymap.set({ "n", "t" }, "<A-h>", function()
  vim.cmd "FloatermToggle"
end, { desc = "FloatermToggle" })

vim.keymap.set({ "n", "t" }, "<A-i>", function()
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

local opts = { noremap = true, silent = true }

map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<Tab>', '<Cmd>BufferNext<CR>', opts)

map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

map('n', '<A-x>', '<Cmd>BufferClose<CR>', opts)
map('n', '<Leader>xo', '<Cmd>BufferClose<CR>', opts)

map('n', '<Leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Leader>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<Leader>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Leader>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
