---@type LazySpec[]
return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "ibhagwan/fzf-lua",
    },
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "Saghen/blink.cmp" },
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1, -- recommend for local model for resource saving
        -- I recommend beginning with a small context window size and incrementally
        -- expanding it, depending on your local computing power. A context window
        -- of 512, serves as an good starting point to estimate your computing
        -- power. Once you have a reliable estimate of your local computing power,
        -- you should adjust the context window to a larger value.
        context_window = 512,
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            model = "qwen2.5-coder:1.5b",
            optional = {
              max_tokens = 100,
              top_p = 0.9,
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          keymap = {
            -- accept whole completion
            accept = "<c-;>",
            -- accept one line
            accept_line = "<c-l>",
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            -- accept_n_lines = '<A-z>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<c-}>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<c-{>",
            dismiss = "<A-e>",
          },
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
    },
  },
  { "nanotee/zoxide.vim" },
  { "bfrg/vim-jqplay", cmd = { "Jqplay", "JqplayScratch", "JqplayScratchNoInput" } },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      ----@type lspconfig.options
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 8192,
              },
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  -- from LazyVim
  -- {
  --   "rcarriga/nvim-notify",
  --   opts = {
  --     render = "compact",
  --   },
  -- },
  -- from LazyVim
  {
    "folke/flash.nvim",
    opts = {
      modes = { search = { enabled = false } },
    },
  },
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
}
