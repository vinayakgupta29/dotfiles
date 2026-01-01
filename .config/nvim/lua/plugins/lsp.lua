-- plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup()

      -- Define your LSP servers
      local servers = {
        html = {},
        cssls = {},
        ts_ls = {},
        emmet_ls = {
          filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
        },
        lua_ls = {},
        pyright = {},
        ltex = {},
        jsonls = {},
        clangd = {},
        gopls = {},
      }

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        -- automatic_installation = true, -- optional, installs missing ones
      })

      -- Capabilities (add cmp_nvim_lsp if you use it)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Global keymaps
      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      -- Set defaults for all LSPs
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.diagnostic.config({ virtual_text = true })
      -- Apply server-specific configs and enable each
      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end,
  },
}
