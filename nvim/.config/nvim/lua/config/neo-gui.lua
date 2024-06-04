-- Set the transparency level for floating windows
vim.opt.winblend = 75
-- Set the transparency level for popup menu
vim.opt.pumblend = 75
vim.g.neovide_refresh_rate = 144
vim.g.neovide_refresh_rate_idle = 10
vim.g.neovide_window_blurred = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_fullscreen = true
-- enables the profiler, which shows a frametime graph in the upper left corner.
vim.g.neovide_profiler = false

vim.g.neovide_floating_blur_amount_x = 4.0
vim.g.neovide_floating_blur_amount_y = 4.0

vim.g.neovide_floating_shadow = true
vim.g.neovide_transparency = 0.6
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
vim.g.neovide_cursor_smooth_blink = true

-- Dynamically Change The Scale At Runtime?
vim.g.neovide_scale_factor = 1.03
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.06)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.06)
end)
