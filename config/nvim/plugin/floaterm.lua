local M = {
  state = {
    floating = {
      buf = -1,
      win = -1,
    },
  },
}

-- Get dimensions of the current window
local function get_window_dimensions()
  local width = vim.o.columns
  local height = vim.o.lines
  return width, height
end

-- Calculate window size and position
local function calculate_window_layout(opts)
  local width, height = get_window_dimensions()

  -- Default to 80% of screen if no size specified
  local win_width = math.floor(width * (opts.width or 0.8))
  local win_height = math.floor(height * (opts.height or 0.8))

  -- Calculate starting position to center the window
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  return {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }
end

-- Create and open the floating window
function M.open_float(opts)
  opts = opts or {}

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Set buffer options
  -- vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  -- vim.api.nvim_buf_set_option(buf, "filetype", opts.filetype or "")

  -- Calculate window layout
  local win_opts = calculate_window_layout(opts)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Set window options
  -- vim.api.nvim_win_set_option(win, "winblend", opts.blend or 0)
  -- vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:Normal")

  -- Return buffer and window IDs for further manipulation
  return { buf = buf, win = win }
end

-- Close the floating window
function M.close_float()
  vim.api.nvim_win_hide(M.state.floating.win)
end

function M.toggle_float()
  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    M.state.floating = M.open_float({ buf = M.state.floating.buf })
    if vim.bo[M.state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    M.close_float()
  end
end

vim.api.nvim_create_user_command("Floaterminal", M.toggle_float, {})

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
vim.keymap.set({ "n", "t" }, "<space>t", M.toggle_float)

return M
