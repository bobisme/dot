return {
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      -- { "<c-h>", ":<C-U>TmuxNavigateLeft<cr>", silent = true },
      -- { "<c-l>", ":<C-U>TmuxNavigateRight<cr>", silent = true },
      { "<c-h>", vim.cmd.TmuxNavigateLeft, silent = true },
      { "<c-l>", vim.cmd.TmuxNavigateRight, silent = true },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      -- Configuration inside setup, or leave empty to use defaults
      require("nvim-surround").setup()
    end,
  },
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>ct", vim.cmd.TSJToggle, desc = "toggle tree" },
      { "<leader>cj", vim.cmd.TSJJoin, desc = "join tree" },
      { "<leader>cs", vim.cmd.TSJSplit, desc = "split tree" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>xx",
        function()
          require("trouble").open()
        end,
        desc = "toggle trouble",
      },
      {
        "<leader>xw",
        function()
          require("trouble").open("workspace_diagnostics")
        end,
        desc = "trouble for workspace",
      },
      {
        "<leader>xd",
        function()
          require("trouble").open("document_diagnostics")
        end,
        desc = "trouble for document",
      },
      {
        "<leader>xq",
        function()
          require("trouble").open("quickfix")
        end,
        desc = "trouble for quickfix",
      },
      {
        "<leader>xl",
        function()
          require("trouble").open("loclist")
        end,
        desc = "trouble for loclist",
      },
      {
        "gR",
        function()
          require("trouble").open("lsp_references")
        end,
        desc = "trouble for LSP refs",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
}
