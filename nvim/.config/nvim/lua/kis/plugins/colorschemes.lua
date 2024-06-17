-- return {
--   "Mofiqul/vscode.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd([[colorscheme vscode]])
--   end,
-- }

-- return {
--   "LunarVim/darkplus.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd([[colorscheme darkplus]])
--   end,
-- }

-- return {
--     'ellisonleao/gruvbox.nvim',
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.cmd[[colorscheme gruvbox]]
--     end
-- }
--
--

-- return {
--   {
--     "arturgoms/moonbow.nvim",
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("moonbow")
--     end,
--   },
-- }

-- return {
--   "bluz71/vim-moonfly-colors",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd([[colorscheme moonfly]])
--   end,
-- }

-- return {
--     'craftzdog/solarized-osaka.nvim',
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("solarized-osaka").setup({
--         styles = {
--             floats = "transparent"
--         },
--       })
--       vim.cmd[[colorscheme solarized-osaka]]
--     end
-- }

return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme catppuccin]])
  end,
  color_overrides = {
    mocha = {
      base = "#000000",
      mantle = "#000000",
      crust = "#000000",
    },
  },
}

--
----
-- return {
-- 	{
-- 		"rose-pine/neovim",
-- 		priority = 1000,
-- 		config = function()
-- 			vim.cmd.colorscheme("rose-pine")
-- 		end,
-- 	},
-- }
--
-- return {
-- 	{
-- 		"dylanaraps/wal.vim",
-- 		priority = 1000,
-- 		config = function()
-- 			vim.cmd.colorscheme("wal")
-- 		end,
-- 	},
-- }
