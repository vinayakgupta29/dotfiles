-- plugins/lsp.lua
local opts = {}
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ltex-ls",
          "prettier",
          "html",
          "cssls",
          "ts_ls",
          "jsonls",
          "clangd",
          "cpplint"
        },
      })

      local lspconfig = require("lspconfig")

      -- HTML
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- CSS
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- JavaScript / TypeScript
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      -- Global keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { noremap = true, silent = true, buffer = event.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
        end,
      })

      -- 🧠 SAFELY call setup_handlers
      local mason_lspconfig = require("mason-lspconfig")
      if mason_lspconfig.setup_handlers then
        mason_lspconfig.setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({})
          end,
        })
      else
        -- fallback if you're on older mason-lspconfig
        local servers = mason_lspconfig.get_installed_servers()
        for _, server in ipairs(servers) do
          lspconfig[server].setup({})
        end
      end
    end,
  },
}
