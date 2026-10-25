local M = {}

-- Find root of clings project
function M.find_clings_root()
  local current_dir = vim.fn.expand "%:p:h"
  if current_dir == "" then
    current_dir = vim.fn.getcwd()
  end
  local marker = vim.fs.find({ ".clings-state.txt", "exercises" }, { path = current_dir, upward = true })[1]
  if marker then
    return vim.fs.dirname(marker)
  end
  -- Check default user path if exists
  local home_clings = vim.fn.expand "~/project/clings"
  if vim.fn.isdirectory(home_clings) == 1 then
    return home_clings
  end
  return vim.fn.getcwd()
end

-- Get exercise name from current buffer
function M.get_current_exercise()
  local file = vim.fn.expand "%:t:r" -- filename without extension (e.g. intro1)
  local path = vim.fn.expand "%:p"
  if path:match "exercises" or path:match "solutions" then
    return file
  end
  return nil
end

-- Run clings command in a clean floating terminal window
local function run_in_float_term(cmd, title)
  local clings_dir = M.find_clings_root()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.min(100, math.floor(vim.o.columns * 0.85))
  local height = math.min(30, math.floor(vim.o.lines * 0.8))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " " .. (title or "Clings") .. " (q or <Esc> to close) ",
    title_pos = "center",
  })

  vim.fn.termopen(cmd, {
    cwd = clings_dir,
    on_exit = function()
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
      vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
    end,
  })
  vim.cmd "startinsert"
end

function M.run(exercise)
  local ex = exercise or M.get_current_exercise()
  local cmd = ex and ("clings run " .. ex) or "clings run"
  run_in_float_term(cmd, "Clings: Run " .. (ex or ""))
end

function M.watch()
  run_in_float_term("clings", "Clings Watch Mode")
end

function M.hint(exercise)
  local ex = exercise or M.get_current_exercise()
  local clings_dir = M.find_clings_root()
  local cmd = ex and ("clings hint " .. ex) or "clings hint"

  local output = vim.fn.systemlist("cd " .. vim.fn.shellescape(clings_dir) .. " && " .. cmd)
  if #output == 0 then
    vim.notify("No hint available for " .. (ex or "current exercise"), vim.log.levels.INFO, { title = "Clings Hint" })
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"

  local width = math.min(80, math.floor(vim.o.columns * 0.8))
  local height = math.min(math.max(#output + 2, 8), math.floor(vim.o.lines * 0.7))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Clings Hint: " .. (ex or "Current Exercise") .. " (q to close) ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
end

function M.check_all()
  run_in_float_term("clings check-all", "Clings Check All")
end

function M.reset(exercise)
  local ex = exercise or M.get_current_exercise()
  if not ex then
    vim.ui.input({ prompt = "Exercise name to reset: " }, function(input)
      if input and input ~= "" then
        M.reset(input)
      end
    end)
    return
  end
  run_in_float_term("clings reset " .. ex, "Clings Reset: " .. ex)
end

function M.setup()
  vim.api.nvim_create_user_command("ClingsRun", function(opts)
    local ex = opts.args ~= "" and opts.args or nil
    M.run(ex)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("ClingsWatch", function()
    M.watch()
  end, {})

  vim.api.nvim_create_user_command("ClingsHint", function(opts)
    local ex = opts.args ~= "" and opts.args or nil
    M.hint(ex)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("ClingsCheck", function()
    M.check_all()
  end, {})

  vim.api.nvim_create_user_command("ClingsReset", function(opts)
    local ex = opts.args ~= "" and opts.args or nil
    M.reset(ex)
  end, { nargs = "?" })
end

return M
