return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme vscode]])
  end,
}

-- return {
--   "LunarVim/darkplus.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd([[colorscheme darkplus]])
--   end,
-- }
