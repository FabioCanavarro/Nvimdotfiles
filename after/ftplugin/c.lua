-- ~/.config/nvim/after/ftplugin/c.lua
local bufnr = vim.api.nvim_get_current_buf()
local map = vim.keymap.set
local opts = function(desc)
  return { buffer = bufnr, silent = true, desc = desc }
end

vim.opt_local.commentstring = "// %s"

-- Clangd Source / Header Toggle
map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", opts "Clangd: Switch Source/Header")
map("n", "<A-o>", "<cmd>ClangdSwitchSourceHeader<cr>", opts "Clangd: Switch Source/Header")

-- Clangd Navigation & Analysis
map("n", "<leader>cA", "<cmd>ClangdAST<cr>", opts "Clangd: AST View")
map("n", "<leader>cT", "<cmd>ClangdTypeHierarchy<cr>", opts "Clangd: Type Hierarchy")
map("n", "<leader>cM", "<cmd>ClangdMemoryUsage<cr>", opts "Clangd: Memory Usage")
map("n", "<leader>cS", "<cmd>ClangdSymbolInfo<cr>", opts "Clangd: Symbol Info")

-- Inlay hints toggle
map("n", "<leader>th", function()
  if vim.lsp.inlay_hint then
    local enabled = not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
    vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
    vim.notify("Inlay hints " .. (enabled and "ENABLED" or "DISABLED"), vim.log.levels.INFO)
  end
end, opts "Toggle Inlay Hints (Buffer)")

-- Testcase runner (CompetiTest)
map("n", "<leader>tr", "<cmd>CompetiTest run<cr>", opts "Test: Run Testcases")
map("n", "<leader>ta", "<cmd>CompetiTest add_testcase<cr>", opts "Test: Add Testcase")
map("n", "<leader>te", "<cmd>CompetiTest edit_testcase<cr>", opts "Test: Edit Testcase")
map("n", "<leader>td", "<cmd>CompetiTest delete_testcase<cr>", opts "Test: Delete Testcase")
map("n", "<leader>tu", "<cmd>CompetiTest show_ui<cr>", opts "Test: Toggle UI")

-- Clings integration
map("n", "<leader>Cr", "<cmd>ClingsRun<cr>", opts "Clings: Run Exercise")
map("n", "<leader>Ch", "<cmd>ClingsHint<cr>", opts "Clings: Show Hint")
map("n", "<leader>Cw", "<cmd>ClingsWatch<cr>", opts "Clings: Watch Mode")
map("n", "<leader>Cc", "<cmd>ClingsCheck<cr>", opts "Clings: Check All")
map("n", "<leader>Cs", "<cmd>ClingsReset<cr>", opts "Clings: Reset Exercise")

-- QEMU integration
map("n", "<leader>qr", "<cmd>QemuRun<cr>", opts "QEMU: Run (make qemu)")
map("n", "<leader>qg", "<cmd>QemuGdb<cr>", opts "QEMU: Debug (make qemu-gdb)")
map("n", "<leader>qk", "<cmd>QemuStop<cr>", opts "QEMU: Stop active instances")
