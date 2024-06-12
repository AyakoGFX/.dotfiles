require("config.lazy")

-- require("ibl") -- this should be above options "transparent bg" do not delet

require("config.Telescope-keymaps")
require("config.autocmds")
require("config.options")
require("config.keymaps")
require("luarocks-nvim")

if vim.g.neovide then
  require("config.neo-gui")
end
-- -- enable trasparent
-- vim.api.nvim_set_hl(0, "normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "normalfloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "linenr", { bg = "none" })
-- vim.api.nvim_set_hl(0, "cursorlinenr", { bg = "none" })
vim.keymap.set("i", "^H", "<C-W>", { noremap = true, silent = true })

-- Set colorscheme when Neovim starts
-- require("vscode").load("light")
-- require("vscode").load("dark")
--vim.cmd("colorscheme tokyonight-night")
--
-- notes
-- vim.g.autoformat = false -- globally
-- vim.b.autoformat = false -- buffer-local
--
--
--
-- Set tab width and indentation for C++ files
