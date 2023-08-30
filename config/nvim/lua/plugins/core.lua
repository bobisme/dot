return {
  -- from LazyVim
  { "rcarriga/nvim-notify", opts = {
    render = "compact",
  } },
  -- from LazyVim
  { "folke/flash.nvim", opts = {
    modes = { search = { enabled = false } },
  } },
  -- from LazyVim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
  -- from LazyVim
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "BufReadPre",
    opts = {
      mappings = {
        add = "ysa", -- Add surrounding in Normal and Visual modes
        delete = "ysd", -- Delete surrounding
        find = "ysf", -- Find surrounding (to the right)
        find_left = "ysF", -- Find surrounding (to the left)
        highlight = "ysh", -- Highlight surrounding
        replace = "ysr", -- Replace surrounding
        update_n_lines = "ysn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
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
  -- from LazyVim
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
    "Wansmer/treesj",
    keys = {
      { "<c-J>", vim.cmd.TSJToggle, desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 1500 },
  },
  -- from LazyVim
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  -- from LazyVim
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
