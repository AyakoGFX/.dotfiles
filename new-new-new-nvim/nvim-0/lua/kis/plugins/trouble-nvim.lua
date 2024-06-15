-- return {
--   {
--     "folke/trouble.nvim",
--     config = function()
--       require("trouble").setup({
--         -- icons = false,
--       })
--
--       vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua require('trouble').toggle()<CR>", { noremap = true, silent = true })
--
--       vim.api.nvim_set_keymap("n", "[t", "<cmd>lua require('trouble').next({ skip_groups = true, jump = true })<CR>", { noremap = true, silent = true })
--
--       vim.api.nvim_set_keymap("n", "]t", "<cmd>lua require('trouble').previous({ skip_groups = true, jump = true })<CR>", { noremap = true, silent = true })
--     end,
--   },
-- }
return{
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>tt",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>tT",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>ts",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>tl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>tL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>tQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
