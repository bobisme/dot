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
  -- fg_rgb = { r = 166, g = 173, b = 200 } -- subtext 0
  fg_rgb = { r = 184, g = 192, b = 224 } -- subtext 1
else
  fg_rgb = { r = fg_rgb.r * 1.75, g = fg_rgb.g * 1.75, b = fg_rgb.b * 1.75 }
end
comment_fg = from_rgb(fg_rgb)

vim.api.nvim_set_hl(0, "Comment", { fg = comment_fg, italic = true })
vim.api.nvim_set_hl(0, "Inlay", { fg = inlay_fg, italic = true })
vim.api.nvim_set_hl(0, "InlayHint", { fg = inlay_fg, italic = true })

vim.api.nvim_set_hl(0, "DiffAdd", { bg = from_rgb({ r = 41.5, g = 56.75, b = 40.25 }) })
vim.api.nvim_set_hl(0, "DiffChange", { bg = from_rgb({ r = 17.0, g = 22.5, b = 41.65 }) })
vim.api.nvim_set_hl(0, "DiffText", { bg = from_rgb({ r = 34.25, g = 45.0, b = 83.3 }) })
vim.api.nvim_set_hl(0, "DiffDelete", {
  fg = from_rgb({ r = 121.5, g = 69.5, b = 84.0 }),
  -- fg = from_rgb({ r = 50.0, g = 0.0, b = 0.0 }),
})

-- require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

vim.cmd("set nonumber norelativenumber")

vim.env.ANTHROPIC_API_KEY = vim.fn.trim(vim.fn.system("pass show api/anthropic"))

-- require("lspconfig").tsserver.setup({
--   settings = {
--     implicitProjectConfiguration = {
--       checkJs = true,
--     },
--   },
-- })

if vim.g.neovide then
  vim.o.guifont = "FantasqueSansM Nerd Font"

  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_cursor_vfx_opacity = 300.0
  vim.g.neovide_cursor_vfx_particle_density = 10.0
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_scale_factor = 1.00
  vim.g.neovide_scroll_animation_length = 0.3
else
  -- Use whatever the terminal emulator's background is
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
end
