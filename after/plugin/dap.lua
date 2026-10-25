local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
  return
end

-- 1. Setup codelldb adapter (via Mason)
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
local codelldb_path = mason_bin .. "/codelldb"

if vim.fn.executable(codelldb_path) == 1 then
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  }
end

-- 2. Setup GDB adapter (native GDB with DAP support)
if vim.fn.executable "gdb" == 1 then
  dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "-i", "dap" },
  }
end

-- 3. C & C++ Configurations
local c_cpp_configs = {
  {
    name = "Launch executable (codelldb)",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Launch executable (gdb)",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Attach to QEMU / xv6-riscv (:26000)",
    type = "gdb",
    request = "attach",
    target = "localhost:26000",
    program = function()
      local default_prog = vim.fn.filereadable(vim.fn.getcwd() .. "/kernel/kernel") == 1
          and (vim.fn.getcwd() .. "/kernel/kernel")
        or (vim.fn.getcwd() .. "/")
      return vim.fn.input("Path to kernel/executable: ", default_prog, "file")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to QEMU / GDB Server (:1234)",
    type = "gdb",
    request = "attach",
    target = "localhost:1234",
    program = function()
      local default_prog = vim.fn.filereadable(vim.fn.getcwd() .. "/kernel/kernel") == 1
          and (vim.fn.getcwd() .. "/kernel/kernel")
        or (vim.fn.getcwd() .. "/")
      return vim.fn.input("Path to kernel/executable: ", default_prog, "file")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to QEMU (custom port)",
    type = "gdb",
    request = "attach",
    target = function()
      local port = vim.fn.input "GDB Server port (default 1234): "
      if port == "" then
        port = "1234"
      end
      return "localhost:" .. port
    end,
    program = function()
      return vim.fn.input("Path to kernel/executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to process (gdb)",
    type = "gdb",
    request = "attach",
    pid = function()
      return require("dap.utils").pick_process()
    end,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.c = c_cpp_configs
dap.configurations.cpp = c_cpp_configs
