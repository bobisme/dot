return {
  { "IndianBoy42/tree-sitter-just" },
  {
    -- NOTE: this will be deprecated when nvim 0.10 is released.
    "nvim-treesitter/playground",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },
}
