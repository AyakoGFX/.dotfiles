return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    local wk = require("which-key")
    wk.register({
      ['<leader>c'] = { name = 'Code', ['_'] = 'which_key_ignore' },
      -- ['<leader>o'] = { name = 'Obsidian', ['_'] = 'which_key_ignore' },
      ['<leader>b'] = { name = 'Buffer', ['_'] = 'which_key_ignore' },
      ['<leader>f'] = { name = 'Find', ['_'] = 'which_key_ignore' },
      ['<leader>s'] = { name = 'Search', ['_'] = 'which_key_ignore' },
      ['<leader>w'] = { name = 'trouble', ['_'] = 'which_key_ignore' },
      ['<leader>t'] = { name = 'Truble', ['_'] = 'which_key_ignore' },
      ['<leader>h'] = { name = 'Harpoon', ['_'] = 'which_key_ignore' },
      ['<leader>q'] = { name = 'Sessions', ['_'] = 'which_key_ignore' },
      ['<leader>r'] = { name = 'rename & dashboard', ['_'] = 'which_key_ignore' },
    })
  end
}
