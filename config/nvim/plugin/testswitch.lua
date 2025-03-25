-- test-switcher.lua
-- A Neovim plugin to switch between source and test files

local M = {}

-- Configuration with defaults
M.config = {
  open_in_split = true, -- Whether to open test files in a vertical split
  patterns = {
    -- Pattern for TypeScript/JavaScript projects
    {
      source_pattern = "^src/(.+)%.ts$",
      test_pattern = "__tests__/%1.test.ts",
      source_from_test_pattern = "^__tests__/(.+)%.test%.ts$",
      source_from_test_replace = "src/%1.ts",
    },
    {
      source_pattern = "^src/(.+)%.js$",
      test_pattern = "__tests__/%1.test.js",
      source_from_test_pattern = "^__tests__/(.+)%.test%.js$",
      source_from_test_replace = "src/%1.js",
    },
    -- Add more patterns for other languages/project structures as needed
  },
  create_non_existing = true, -- Create test file if it doesn't exist
}

-- Helper function to check if a file exists
local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

-- Function to create a new test file with basic template
local function create_test_file(path, source_path)
  -- Get the filename without path and extension
  local filename = vim.fn.fnamemodify(source_path, ":t:r")

  -- Create directories if they don't exist
  local dir = vim.fn.fnamemodify(path, ":h")
  vim.fn.mkdir(dir, "p")

  -- Create a basic test template
  local file = io.open(path, "w")
  if file then
    file:write(string.format(
      [[
describe('%s', () => {
  it('works', () => {
    // TODO: Write tests
    expect(false).toBe(true);
  });
});
]],
      filename
    ))
    file:close()
    return true
  end
  return false
end

-- Function to open a file in the rightmost split
function M.open_in_right_split(path)
  -- Check if we want to use splits
  if M.config.open_in_split then
    -- Get the current window info
    local window_count = vim.fn.winnr("$")
    local current_win = vim.fn.winnr()

    -- Check if we're already in a vertical layout
    local win_width = vim.fn.winwidth(0)
    local editor_width = vim.o.columns

    -- If this is a fresh Neovim instance or a single window that takes up most of the screen
    if window_count <= 1 or (win_width > editor_width * 0.9) then
      vim.cmd("rightbelow vsplit " .. path)
      return
    end

    -- Try to find the rightmost window
    local rightmost_win = current_win
    local rightmost_pos = vim.fn.getwininfo(vim.fn.win_getid(rightmost_win))[1].wincol

    -- Iterate through all windows to find the rightmost one
    for i = 1, window_count do
      local win_info = vim.fn.getwininfo(vim.fn.win_getid(i))[1]

      if win_info.wincol > rightmost_pos then
        rightmost_win = i
        rightmost_pos = win_info.wincol
      end
    end

    -- Go to the rightmost window and open the file there
    vim.cmd(rightmost_win .. "wincmd w")
    vim.cmd("edit " .. path)
  else
    -- Just open in the current window
    vim.cmd("edit " .. path)
  end
end

-- Function to find the corresponding test file for the current buffer
function M.find_test_file()
  local current_file = vim.fn.expand("%:p")
  local relative_path = vim.fn.fnamemodify(current_file, ":~:.")

  for _, pattern in ipairs(M.config.patterns) do
    -- Check if we're in a source file
    local source_match = string.match(relative_path, pattern.source_pattern)
    if source_match then
      local test_path = string.gsub(relative_path, pattern.source_pattern, pattern.test_pattern)

      -- Check if the test file exists
      if file_exists(test_path) then
        M.open_in_right_split(test_path)
      elseif M.config.create_non_existing then
        -- Create the test file if it doesn't exist
        if create_test_file(test_path, relative_path) then
          M.open_in_right_split(test_path)
        else
          vim.notify("Failed to create test file: " .. test_path, vim.log.levels.ERROR)
        end
      else
        vim.notify("Test file doesn't exist: " .. test_path, vim.log.levels.WARN)
      end
      return
    end

    -- Check if we're in a test file
    local test_match = string.match(relative_path, pattern.source_from_test_pattern)
    if test_match then
      local source_path = string.gsub(relative_path, pattern.source_from_test_pattern, pattern.source_from_test_replace)

      -- Check if the source file exists
      if file_exists(source_path) then
        -- Just edit the source file in the current window
        vim.cmd("edit " .. source_path)
      else
        vim.notify("Source file doesn't exist: " .. source_path, vim.log.levels.WARN)
      end
      return
    end
  end

  vim.notify("Could not determine test file for: " .. relative_path, vim.log.levels.WARN)
end

-- Setup function
function M.setup(opts)
  -- Merge user config with defaults
  if opts then
    M.config = vim.tbl_deep_extend("force", M.config, opts)
  end

  -- Create user command
  vim.api.nvim_create_user_command("TestSwitcher", function()
    M.find_test_file()
  end, {})

  -- Return the module for chaining
  return M
end

M.setup()
vim.keymap.set("n", "<leader>T", ":TestSwitcher<CR>", { noremap = true, silent = true, desc = "Open test file" })

return M
