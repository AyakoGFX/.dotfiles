return {
  {
    "mfussenegger/nvim-dap",
    opts = {},
  }
}

local dap = require('dap')

}

vim.keymap.set('n', '<F5>', require('dap').continue)
vim.keymap.set('n', '<F10>', require('dap').step_over)
vim.keymap.set('n', '<F11>', require('dap').step_into)
vim.keymap.set('n', '<F12>', require('dap').step_out)
vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoi

