require('telescope').setup({
})

local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>sb", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "live grep in opened Buffers",
	})
end, { desc = "live grep in opened Buffers" })


vim.keymap.set("n", "<leader>sf", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "search in current file" })
