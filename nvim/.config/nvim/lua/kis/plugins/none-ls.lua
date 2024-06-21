-- none-ls used for formatting
return {
	"nvimtools/none-ls.nvim",
	config = function()

		local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
        -- c++
				null_ls.builtins.formatting.clang_format,

        -- go 
        null_ls.builtins.formatting.goimports_reviser,
				null_ls.builtins.formatting.gofumpt,
				null_ls.builtins.formatting.golines,
        -- null_ls.builtins.completion.spell,
				-- null_ls.builtins.formatting.ast_grep
				-- null_ls.builtins.formatting.prettier,
				-- null_ls.builtins.diagnostics.erb_lint,
        --golines                              
				-- null_ls.builtins.diagnostics.rubocop,
			  },
		})
-- ast_grep
		-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    vim.keymap.set("n", "gf", vim.lsp.buf.format, { desc = "Format Document" })
	end,
}
