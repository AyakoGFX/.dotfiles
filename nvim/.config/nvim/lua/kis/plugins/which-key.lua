-- return {
-- 	"folke/which-key.nvim",
-- 	event = "VeryLazy",
-- 	init = function()
-- 	end,
-- 	opts = {
-- 		-- your configuration comes here
-- 		-- or leave it empty to use the default settings
-- 		-- refer to the configuration section below
-- 	},
-- }
-- return { -- Useful plugin to show you pending keybinds.
-- 	"folke/which-key.nvim",
-- 	event = "VimEnter", -- Sets the loading event to 'VimEnter'
-- 	config = function() -- This is the function that runs AFTER loading
-- 		vim.o.timeout = true
-- 		vim.o.timeoutlen = 300
-- 		require("which-key").setup()
--
-- 		-- Document existing key chains
-- 		require("which-key").register({
--         ['<leader>c'] = { name = 'Code', _ = 'which_key_ignore' },
--         ['<leader>o'] = { name = 'Obsidian', _ = 'which_key_ignore' },
--         ['<leader>b'] = { name = 'Buffer', _ = 'which_key_ignore' },
--         ['<leader>f'] = { name = 'Find', _ = 'which_key_ignore' },
--         ['<leader>s'] = { name = 'Search', _ = 'which_key_ignore' },
--         ['<leader>w'] = { name = 'trouble', _ = 'which_key_ignore' },
--         ['<leader>t'] = { name = 'Truble', _ = 'which_key_ignore' },
--         ['<leader>h'] = { name = 'Harpoon', _ = 'which_key_ignore' },
--         ['<leader>q'] = { name = 'Sessions', _ = 'which_key_ignore' },
--         ['<leader>r'] = { name = 'rename & dashboard', _ = 'which_key_ignore' },
-- 		})
-- 	end,
-- }
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  },
}
