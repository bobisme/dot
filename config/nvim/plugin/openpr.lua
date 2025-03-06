vim.api.nvim_create_user_command("OpenPR", function()
  -- Get the commit hash from the blame view
  local line_nr = vim.fn.line(".")
  local commit_hash = vim.fn.matchstr(vim.fn.getline("."), "^\\zs\\x\\+\\ze")

  -- Alternative methods to get commit hash if needed
  if not commit_hash or commit_hash == "" then
    local blame_info = vim.fn.FugitiveBlameInfo(line_nr)
    if blame_info and type(blame_info) == "table" then
      commit_hash = blame_info.commit or blame_info.sha or blame_info[1]
    end
  end

  if not commit_hash or commit_hash == "" then
    print("Could not determine commit hash. Are you in a fugitive blame view?")
    return
  end

  print("Using commit hash: " .. commit_hash)

  -- Get the commit message for this commit
  local commit_message = vim.fn.system("git show -s --format=%B " .. commit_hash)
  commit_message = vim.fn.trim(commit_message)

  print("Commit message: " .. commit_message)

  -- Look for the pattern (#number)
  local pr_pattern = "%(#(%d+)%)"
  local pr_number = commit_message:match(pr_pattern)

  if pr_number then
    print("Found PR #" .. pr_number)

    -- Get organization and repository name from origin remote
    local origin_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
    local org_repo = ""

    -- Extract org/repo from various URL formats
    if origin_url:match("github.com[:/]([^/]+/[^/%.]+)") then
      org_repo = origin_url:match("github.com[:/]([^/]+/[^/%.]+)")
      -- Remove .git suffix if present
      org_repo = org_repo:gsub("%.git$", "")
    else
      print("Could not extract organization/repository from remote URL")
      return
    end

    -- Construct the URL directly
    local pr_url = "https://github.com/" .. org_repo .. "/pull/" .. pr_number
    print("Opening URL: " .. pr_url)

    -- Use appropriate open command based on OS
    local open_cmd = "open"
    if vim.fn.has("unix") == 1 and vim.fn.has("mac") == 0 then
      open_cmd = "xdg-open"
    elseif vim.fn.has("win32") == 1 then
      open_cmd = "start"
    end

    vim.fn.system(open_cmd .. " " .. pr_url)
  else
    -- Fallback: search for PR containing this commit using GitHub CLI
    print("No PR number found in commit message, trying GitHub CLI search...")

    -- Use appropriate open command based on OS
    local open_cmd = "open"
    if vim.fn.has("unix") == 1 and vim.fn.has("mac") == 0 then
      open_cmd = "xdg-open"
    elseif vim.fn.has("win32") == 1 then
      open_cmd = "start"
    end

    local cmd = "gh pr list --search " .. commit_hash .. " --json url --jq '.[0].url' | xargs " .. open_cmd
    vim.fn.system(cmd)
  end
end, { desc = "Open GitHub PR for commit in blame view" })

-- Optional: Add a keybinding
vim.keymap.set("n", "<leader>gp", ":OpenPR<CR>", { silent = true, desc = "Open GitHub PR for commit" })
