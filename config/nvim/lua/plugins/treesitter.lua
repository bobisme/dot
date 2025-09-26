return {
  { "IndianBoy42/tree-sitter-just" },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
    },
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
      return {
        autotag = { enable = true },
        endwise = { enable = true },
      }
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPost" },
}
