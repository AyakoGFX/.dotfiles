-- none-ls used for formatting
return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.clang_format,
				-- null_ls.builtins.formatting.ast_grep
				-- null_ls.builtins.formatting.prettier,
				-- null_ls.builtins.diagnostics.erb_lint,
				-- null_ls.builtins.diagnostics.rubocop,
			},
		})
-- ast_grep
		-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format Document" })
	end,
}
