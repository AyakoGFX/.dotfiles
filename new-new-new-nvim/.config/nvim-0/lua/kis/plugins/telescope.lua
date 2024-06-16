return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
    dependencies = {
      "jvgrootveld/telescope-zoxide",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim"
    }
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<C-f>", builtin.find_files, { desc = "Find files (Ctrl + F)" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Open old files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List buffers" })
      vim.keymap.set("n", "<leader>fB", builtin.builtin, { desc = "List built-in commands" })


      vim.keymap.set("n", "<leader><space>", require("telescope").extensions.zoxide.list, { desc = "List zoxide directories" })

      require("telescope").load_extension('zoxide')
			require("telescope").load_extension("ui-select")
		end,
	},
}
-- https://github.com/nvim-telescope/telescope.nvim
