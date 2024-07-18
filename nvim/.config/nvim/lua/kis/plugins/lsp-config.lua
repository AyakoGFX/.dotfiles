return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
    opts = {}, -- Ensure this table is closed properly
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local util = require("lspconfig/util")
      local lspconfig = require("lspconfig")

      -- Lua Language Server setup
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
              maxPreload = 10000, -- Set the maximum number of files to preload
              preloadFileSize = 1000, -- Set the maximum file size to preload (in KB)
              checkThirdParty = false, -- Disable third-party checking if not needed
            },
          },
        },
      })

      -- TypeScript Server setup
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      -- python Server setup
      lspconfig.pylsp.setup({
        capabilities = capabilities,
      })

      -- Clangd (C/C++) setup
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      -- HTML setup
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- Go Language Server setup
      lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
          },
        },
      })

      -- Key mappings for LSP functions
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
    end,
  },
}
