---@type LazySpec[]
return {
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  },
  { "nanotee/zoxide.vim" },
  { "bfrg/vim-jqplay", cmd = { "Jqplay", "JqplayScratch", "JqplayScratchNoInput" } },
  ---@type LazySpec
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>hm",
        function()
          require("harpoon.mark").add_file()
        end,
        descf = "add file to harpoon list",
      },
      {
        "<leader>hh",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "toggle quick menu",
      },
      {
        "<c-7>",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "jump to 1",
      },
      {
        "<c-8>",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "jump to 2",
      },
      {
        "<c-9>",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "jump to 3",
      },
      {
        "<c-0>",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "jump to 4",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ee", ":Neotree filesystem focus<cr>", desc = "focus file tree", silent = true },
      { "<leader>ec", ":Neotree close<cr>", desc = "close neo tree", silent = true },
      { "<leader>eb", ":Neotree buffers focus<cr>", desc = "focus buffers tree", silent = true },
      { "<leader>eg", ":Neotree git_status focus<cr>", desc = "focus git tree", silent = true },
    },
    opts = {
      window = {
        width = 30,
      },
      source_selector = {
        winbar = true,
      },
      -- integrate with harpoon
      filesystem = {
        components = {
          harpoon_index = function(config, node, state)
            local Marked = require("harpoon.mark")
            local path = node:get_id()
            local succuss, index = pcall(Marked.get_index_of, path)
            if succuss and index and index > 0 then
              return {
                text = string.format("─►%d", index),
                highlight = config.highlight or "NeoTreeDirectoryIcon",
              }
            else
              return {}
            end
          end,
        },
        renderers = {
          file = {
            { "icon" },
            { "name", use_git_status_colors = true },
            -- { "harpoon_index" }, --> This is what actually adds the component in where you want it
            { "diagnostics" },
            { "git_status", highlight = "NeoTreeDimText" },
          },
        },
      },
    },
  },
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
        tailwindcss = {
          filetypes_exclude = { "markdown" },
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          local tw = require("lspconfig.server_configurations.tailwindcss")
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, tw.default_config.filetypes)
        end,
      },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      tools = {
        inlay_hints = {
          parameter_hints_prefix = ": ",
          other_hints_prefix = "› ",
          highlight = "Inlay",
        },
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
  {
    -- from LazyVim
    "echasnovski/mini.surround",
    version = "*",
    event = "BufReadPre",
  },
  -- {
  --   "mhartington/formatter.nvim",
  --   cmd = { "Format", "FormatLock", "FormatWrite", "FormatWriteLock" },
  --   ft = { "asm" },
  --   opts = {
  --     filetype = {
  --       asm = {
  --         function()
  --           return {
  --             exe = "asmfmt",
  --             args = {},
  --             stdin = true,
  --           }
  --         end,
  --       },
  --       python = {
  --         function()
  --           return {
  --             exe = "black",
  --             args = { "-" },
  --             stdin = true,
  --           }
  --         end,
  --       },
  --     },
  --   },
  --   init = function()
  --     local group = vim.api.nvim_create_augroup("FormatterOnSave", { clear = true })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       pattern = { "*.s", "*.py" },
  --       command = "silent! Format",
  --       group = group,
  --     })
  --     -- vim.cmd([[autocmd BufWritePre *.s Format]])
  --   end,
  -- },
  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      api_key_cmd = "pass show openapi/nvim",
      actions_paths = { "/home/bob/.config/nvim/chatgpt-actions.json" },
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
    dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls.nvim" },
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
