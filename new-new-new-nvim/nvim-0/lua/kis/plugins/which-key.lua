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
return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs AFTER loading
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").register({
			-- lsp keys
			-- ["<leader>gd"] = { name = "definition", _ = "which_key_ignore" },
			-- ["<leader>gr"] = { name = "references", _ = "which_key_ignore" },
			-- ["<leader>ca"] = { name = "code_action", _ = "which_key_ignore" },
			-- ["<leader>rn"] = { name = "rename", _ = "which_key_ignore" },
			-- ["<leader>gf"] = { name = "format-buffer", _ = "which_key_ignore" },
		})
	end,
}
