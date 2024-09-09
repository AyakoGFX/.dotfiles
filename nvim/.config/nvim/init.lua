require("kis.opt")
require("kis.keymaps")
require("kis.lazy")
require("kis.autoCMD")


-- :wsudo in Neovim to save the file with sudo privileges.
vim.api.nvim_create_user_command('Wsudo', function()
  vim.cmd('w !sudo tee % > /dev/null')
end, {})

-- vim.api.nvim_set_hl(0, "normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "normalfloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "linenr", { bg = "none" })
-- vim.api.nvim_set_hl(0, "cursorlinenr", { bg = "none" })

-- init.lua
-- vim.cmd('colorscheme desert')
-- vim.cmd('colorscheme dawn')
-- vim.cmd('colorscheme vimvscode')
-- blue
-- darkblue
-- default
-- delek
-- desert
-- elflord
-- evening
-- habamax
-- industry
-- koehler
-- lunaperche
-- morning
-- murphy
-- pablo
-- peachpuff
-- quiet
-- retrobox
-- ron
-- shine
-- slate
-- sorbet
-- torte
-- vim.lua
-- wildcharm
-- zaibatsu
-- zellner
