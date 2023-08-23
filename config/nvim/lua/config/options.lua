-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

if vim.g.neovide then
  vim.o.guifont = "FantasqueSansM Nerd Font"
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_cursor_vfx_particle_density = 10.0
  vim.g.neovide_cursor_vfx_opacity = 300.0
end
