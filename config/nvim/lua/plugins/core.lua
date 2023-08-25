return {
  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      api_key_cmd = "pass show openapi/nvim",
    },
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTRun", "ChatGPTEditWithInstructions", "ChatGPTCompleteCode" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
    },
    opts = {
      autotag = { enable = true },
      endwise = { enable = true },
    },
  },
  { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPost" },
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
  },
  { "LhKipp/nvim-nu", ft = "nu" },
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<c-h>", vim.cmd.TmuxNavigateLeft, silent = true },
      { "<c-l>", vim.cmd.TmuxNavigateRight, silent = true },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "BufReadPost",
  },
  {
    "Wansmer/treesj",
    keys = {
      { "<c-J>", vim.cmd.TSJToggle, desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 1500 },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = {
      -- ctrl + n to select next item
      -- ctrl + h to select prev item
      -- ctrl + l to complete
      -- ctrl + l to move to next position
      -- ctrl + h to move to prev position
      mapping = {
        ["<c-l>"] = require("cmp").mapping(function(fallback)
          local cmp = require("cmp")
          local luasnip = require("luasnip")

          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() and cmp.get_active_entry() then
            cmp.confirm()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<c-h>"] = require("cmp").mapping(function(fallback)
          local cmp = require("cmp")
          local luasnip = require("luasnip")
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
    },
  },
}
