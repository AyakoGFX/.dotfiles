return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    local wk = require("which-key")

    -- Register named groups for <leader> keys
    wk.register({
      ['<leader>c'] = { name = 'Code', ['_'] = 'which_key_ignore' },
      ['<leader>b'] = { name = 'Buffer', ['_'] = 'which_key_ignore' },
      ['<leader>f'] = { name = 'Find', ['_'] = 'which_key_ignore' },
      ['<leader>s'] = { name = 'Search', ['_'] = 'which_key_ignore' },
      ['<leader>w'] = { name = 'Windows', ['_'] = 'which_key_ignore' },
      ['<leader>t'] = { name = 'Trouble', ['_'] = 'which_key_ignore' },
      ['<leader>h'] = { name = 'Harpoon', ['_'] = 'which_key_ignore' },
      ['<leader>q'] = { name = 'Sessions', ['_'] = 'which_key_ignore' },
      ['<leader>g'] = { name = 'Git', ['_'] = 'which_key_ignore' },
      ['<leader>r'] = { name = 'Rename & Dashboard', ['_'] = 'which_key_ignore' },
    })
  end
}
