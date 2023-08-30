return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      rust_analyzer = {
        settings = {
          check = {
            command = "clippy",
          },
        },
      },
    },
  },
}
