vim.keymap.set({ "n", "v" }, "<c-k>", "10k", { desc = "Move up 10 lines.", remap = true })
vim.keymap.set({ "n", "v" }, "<c-j>", "10j", { desc = "Move down 10 lines.", remap = true })
vim.keymap.set({ "n" }, "<c-;>", "m':norm A;<cr>`'", { desc = "append semicolon;", remap = true, silent = true })
vim.keymap.set({ "n" }, "<c-,>", "m':norm A,<cr>`'", { desc = "append comma,", remap = true, silent = true })
