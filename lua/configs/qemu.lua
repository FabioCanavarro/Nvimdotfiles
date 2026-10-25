local M = {}

-- Find project root with Makefile or qemu
function M.find_qemu_project_root()
  local current_dir = vim.fn.expand "%:p:h"
  if current_dir == "" then
    current_dir = vim.fn.getcwd()
  end
  local root = vim.fs.find({ "Makefile", "makefile" }, { path = current_dir, upward = true })[1]
  if root then
    return vim.fs.dirname(root)
  end
  return vim.fn.getcwd()
end

-- Open terminal split at bottom for QEMU execution
local function run_in_term_split(cmd, title)
  local root = M.find_qemu_project_root()
  vim.cmd "botright 14split"
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  vim.fn.termopen(cmd, {
    cwd = root,
    on_exit = function(_, exit_code)
      vim.notify((title or "QEMU") .. " exited with code " .. exit_code, vim.log.levels.INFO)
    end,
  })
  vim.cmd "startinsert"
end

function M.run()
  local root = M.find_qemu_project_root()
  local makefile = root .. "/Makefile"
  local cmd = "make qemu"
  if vim.fn.filereadable(makefile) == 1 then
    local content = vim.fn.readfile(makefile)
    local has_qemu = false
    for _, line in ipairs(content) do
      if line:match "^qemu:" then
        has_qemu = true
        break
      end
    end
    if not has_qemu then
      cmd = "qemu-system-riscv64"
    end
  else
    cmd = "qemu-system-riscv64"
  end

  run_in_term_split(cmd, "QEMU (" .. cmd .. ")")
end

function M.debug()
  local root = M.find_qemu_project_root()
  local makefile = root .. "/Makefile"
  local cmd = "make qemu-gdb"
  if vim.fn.filereadable(makefile) == 1 then
    local content = vim.fn.readfile(makefile)
    local has_gdb = false
    for _, line in ipairs(content) do
      if line:match "^qemu%-gdb:" then
        has_gdb = true
        break
      end
    end
    if not has_gdb then
      cmd = "make qemu QEMUEXTRA='-s -S'"
    end
  else
    cmd = "qemu-system-riscv64 -s -S"
  end

  run_in_term_split(cmd, "QEMU GDB Server (" .. cmd .. ")")
  vim.notify(
    "QEMU GDB Server started! Press <leader>dc to attach DAP debugger.",
    vim.log.levels.INFO,
    { title = "QEMU GDB" }
  )
end

function M.stop()
  vim.fn.system "killall -9 qemu-system-riscv64 qemu-system-x86_64 2>/dev/null"
  vim.notify("Killed active QEMU instances", vim.log.levels.WARN, { title = "QEMU" })
end

function M.setup()
  vim.api.nvim_create_user_command("QemuRun", function()
    M.run()
  end, {})

  vim.api.nvim_create_user_command("QemuGdb", function()
    M.debug()
  end, {})

  vim.api.nvim_create_user_command("QemuStop", function()
    M.stop()
  end, {})
end

return M
