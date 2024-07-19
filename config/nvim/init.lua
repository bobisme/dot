-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd.set("noswapfile")

local colorscheme = "catppuccin"

local to_rgb = function(color)
  local r = math.floor(color / 65536)
  color = color - (r * 65536)
  local g = math.floor(color / 256)
  local b = color - (g * 256)
  return { r = r, g = g, b = b }
end

local from_rgb = function(color)
  return math.floor(math.min(color.r, 255)) * 65536
    + math.floor(math.min(color.g, 255)) * 256
    + math.floor(math.min(color.b, 255))
end

vim.cmd.colorscheme(colorscheme)

-- Make comments lighter so you can read them.
local comment_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
local inlay_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg

local fg_rgb = to_rgb(comment_fg)
if colorscheme == "catppuccin" then
  fg_rgb = { r = fg_rgb.r * 1.4, g = fg_rgb.g * 1.4, b = fg_rgb.b * 1.4 }
else
  fg_rgb = { r = fg_rgb.r * 1.75, g = fg_rgb.g * 1.75, b = fg_rgb.b * 1.75 }
end
comment_fg = from_rgb(fg_rgb)

vim.api.nvim_set_hl(0, "Comment", { fg = comment_fg, italic = true })
vim.api.nvim_set_hl(0, "Inlay", { fg = inlay_fg, italic = true })
vim.api.nvim_set_hl(0, "InlayHint", { fg = inlay_fg, italic = true })

vim.api.nvim_set_hl(0, "DiffAdd", { bg = from_rgb({ r = 10.0, g = 50.0, b = 20.0 }) })
vim.api.nvim_set_hl(0, "DiffChange", { bg = from_rgb({ r = 0.0, g = 0.0, b = 50.0 }) })
vim.api.nvim_set_hl(0, "DiffText", { bg = from_rgb({ r = 20.0, g = 20.0, b = 200.0 }) })
vim.api.nvim_set_hl(0, "DiffDelete", {
  bg = from_rgb({ r = 50.0, g = 0.0, b = 0.0 }),
  fg = from_rgb({ r = 150.0, g = 50.0, b = 50.0 }),
})

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

vim.cmd("set nonumber norelativenumber")

-- require("lspconfig").tsserver.setup({
--   settings = {
--     implicitProjectConfiguration = {
--       checkJs = true,
--     },
--   },
-- })
