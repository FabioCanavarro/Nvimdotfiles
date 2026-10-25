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

map("n", "<Leader>wp", function()
  local picked_window_id = require("window-picker").pick_window()
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end, { desc = "Pick window" })

map("n", "<Leader>wf", function()
  -- Find the first focusable floating window and jump to it
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" and config.focusable then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = "Focus floating window" })

-- LSP Code / Action Namespace
map({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<Leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<Leader>cf", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format document" })

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

-- LeetCode
map("n", "<Leader>ll", "<cmd>Leet<cr>", { desc = "LeetCode Dashboard" })
map("n", "<Leader>lr", "<cmd>Leet run<cr>", { desc = "LeetCode Run Solution" })
map("n", "<Leader>ls", "<cmd>Leet submit<cr>", { desc = "LeetCode Submit Solution" })
map("n", "<Leader>ld", "<cmd>Leet daily<cr>", { desc = "LeetCode Daily Problem" })
map("n", "<Leader>lR", "<cmd>Leet random<cr>", { desc = "LeetCode Random Problem" })
map("n", "<Leader>lt", "<cmd>Leet test<cr>", { desc = "LeetCode Test Case" })
map("n", "<Leader>lc", "<cmd>Leet console<cr>", { desc = "LeetCode Toggle Console" })
map("n", "<Leader>lD", "<cmd>Leet desc<cr>", { desc = "LeetCode Toggle Description" })
map("n", "<Leader>lo", "<cmd>Leet open<cr>", { desc = "LeetCode Open in Browser" })
map("n", "<Leader>lL", "<cmd>Leet list<cr>", { desc = "LeetCode Problem List" })

-- Setup Clings & QEMU commands
pcall(function()
  require("configs.clings").setup()
  require("configs.qemu").setup()
end)

-- C/C++ & Clangd Navigation
map("n", "<Leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Clangd Switch Source/Header" })
map("n", "<A-o>", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Clangd Switch Source/Header" })
map("n", "<Leader>cA", "<cmd>ClangdAST<cr>", { desc = "Clangd AST View" })
map("n", "<Leader>cT", "<cmd>ClangdTypeHierarchy<cr>", { desc = "Clangd Type Hierarchy" })
map("n", "<Leader>cM", "<cmd>ClangdMemoryUsage<cr>", { desc = "Clangd Memory Usage" })
map("n", "<Leader>cS", "<cmd>ClangdSymbolInfo<cr>", { desc = "Clangd Symbol Info" })

-- Inlay hints toggle (<leader>th & <leader>pi)
map("n", "<Leader>th", function()
  if vim.lsp.inlay_hint then
    local enabled = not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
    vim.lsp.inlay_hint.enable(enabled, { bufnr = 0 })
    vim.notify("Inlay hints " .. (enabled and "ENABLED" or "DISABLED"), vim.log.levels.INFO)
  end
end, { desc = "Toggle Inlay Hints" })

-- Testcase Runner (CompetiTest)
map("n", "<Leader>tr", "<cmd>CompetiTest run<cr>", { desc = "Test: Run Testcases" })
map("n", "<Leader>ta", "<cmd>CompetiTest add_testcase<cr>", { desc = "Test: Add Testcase" })
map("n", "<Leader>te", "<cmd>CompetiTest edit_testcase<cr>", { desc = "Test: Edit Testcase" })
map("n", "<Leader>td", "<cmd>CompetiTest delete_testcase<cr>", { desc = "Test: Delete Testcase" })
map("n", "<Leader>tu", "<cmd>CompetiTest show_ui<cr>", { desc = "Test: Toggle UI" })

-- Clings integration (<leader>C...)
map("n", "<Leader>Cr", "<cmd>ClingsRun<cr>", { desc = "Clings: Run Exercise" })
map("n", "<Leader>Ch", "<cmd>ClingsHint<cr>", { desc = "Clings: Show Hint" })
map("n", "<Leader>Cw", "<cmd>ClingsWatch<cr>", { desc = "Clings: Watch Mode" })
map("n", "<Leader>Cc", "<cmd>ClingsCheck<cr>", { desc = "Clings: Check All" })
map("n", "<Leader>Cs", "<cmd>ClingsReset<cr>", { desc = "Clings: Reset Exercise" })

-- QEMU integration (<leader>q...)
map("n", "<Leader>qr", "<cmd>QemuRun<cr>", { desc = "QEMU: Run (make qemu)" })
map("n", "<Leader>qg", "<cmd>QemuGdb<cr>", { desc = "QEMU: Debug (make qemu-gdb)" })
map("n", "<Leader>qk", "<cmd>QemuStop<cr>", { desc = "QEMU: Stop active instances" })

