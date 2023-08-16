return {
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
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "Wansmer/treesj",
    keys = {
      { "J", vim.cmd.TSJToggle, desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 1500 },
  },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
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
