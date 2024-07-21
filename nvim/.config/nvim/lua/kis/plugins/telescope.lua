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
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List buffers" })
      vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "List built-in commands" })
      vim.keymap.set("n", "<leader>sf", builtin.current_buffer_fuzzy_find, { desc = "Search Current File" })


      vim.keymap.set("n", "<leader>sb", function()
        builtin.live_grep({
          grep_open_files = true, prompt_title = "live grep in opened Buffers",})
      end, { desc = "live grep in opened Buffers" })


      vim.keymap.set("n", "<leader><space>", require("telescope").extensions.zoxide.list, { desc = "List zoxide directories" })

      require("telescope").load_extension('zoxide')
			require("telescope").load_extension("ui-select")
		end,
	},
}
-- https://github.com/nvim-telescope/telescope.nvim
