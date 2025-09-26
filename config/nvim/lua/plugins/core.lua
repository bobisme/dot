---@type LazySpec[]
return {
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
          -- accept whole completion
          accept = "<A-y>",
          -- -- accept one line
          -- accept_line = '<A-a>',
          -- -- accept n lines (prompts for number)
          -- -- e.g. "A-z 2 CR" will accept 2 lines
          -- accept_n_lines = '<A-z>',
          -- -- Cycle to prev completion item, or manually invoke completion
          -- prev = "<c-{>",
          -- -- Cycle to next completion item, or manually invoke completion
          -- next = "<c-}>",
          -- dismiss = '<A-e>',
        },
      },
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 512,
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:1.5b",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
    },
  },
  "tpope/vim-fugitive",
  { "nanotee/zoxide.vim" },
  { "bfrg/vim-jqplay", cmd = { "Jqplay", "JqplayScratch", "JqplayScratchNoInput" } },
  {
    "neovim/nvim-lspconfig",
    opts = {
      ----@type lspconfig.options
      servers = {
        -- rust_analyzer = {
        --   settings = {
        --     ["rust-analyzer"] = {
        --       cargo = {
        --         allFeatures = false,
        --       },
        --       checkOnSave = {
        --         allFeatures = false,
        --       },
        --     },
        --   },
        -- },
        -- tailwindcss = {
        --   filetypes_exclude = { "markdown" },
        -- },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
        -- tailwindcss = function(_, opts)
        --   local tw = require("lspconfig.server_configurations.tailwindcss")
        --   --- @param ft string
        --   opts.filetypes = vim.tbl_filter(function(ft)
        --     return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
        --   end, tw.default_config.filetypes)
        -- end,
      },
    },
  },
  {
    -- from LazyVim
    "rcarriga/nvim-notify",
    opts = {
      render = "compact",
    },
  },
  {
    -- from LazyVim
    "folke/flash.nvim",
    opts = {
      modes = { search = { enabled = false } },
    },
  },
  {
    -- from LazyVim
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
        hover = {
          enabled = false,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
        -- lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
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
    -- dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls.nvim" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
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
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<c-l>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<c-h>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      opts.sources = cmp.config.sources({
        { name = "cody" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
