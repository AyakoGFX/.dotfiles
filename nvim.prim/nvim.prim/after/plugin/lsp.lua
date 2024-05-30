-- Call the function .extend_lspconfig() from lsp-zero before setting up language servers
local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

-- Set up mason.nvim first
require('mason').setup({})

-- Then set up mason-lspconfig to manage the installation of LSP servers
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'eslint','rust_analyzer', 'emmet_language_server','emmet_ls','html','cssls','cssmodules_ls', 'css_variables', 'unocss'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

-- Now you can proceed with other configurations or customizations
require('lsp-zero').preset("recommended")

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = require('lsp-zero').defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

-- Customize LSP preferences if needed
require('lsp-zero').set_preferences({
  sign_icons = {},
})

-- Now, you can directly attach the LSP functions without using the lsp-config module
require('lspconfig').tsserver.setup({
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  end
})

