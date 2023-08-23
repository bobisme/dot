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
local fg_rgb = to_rgb(comment_fg)
if colorscheme == "catppuccin" then
  fg_rgb.r = fg_rgb.r * 1.4
  fg_rgb.g = fg_rgb.g * 1.4
  fg_rgb.b = fg_rgb.b * 1.4
else
  fg_rgb.r = fg_rgb.r * 1.75
  fg_rgb.g = fg_rgb.g * 1.75
  fg_rgb.b = fg_rgb.b * 1.75
end
comment_fg = from_rgb(fg_rgb)
vim.api.nvim_set_hl(0, "Comment", { fg = comment_fg, italic = true })
