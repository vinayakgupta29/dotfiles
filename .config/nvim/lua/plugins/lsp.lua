-- plugins/lsp.lua
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},

		config = function()
			local servers = {
				html = {},
				cssls = {},
				ts_ls = {},

				emmet_ls = {
					filetypes = {
						"html",
						"css",
						"javascriptreact",
						"typescriptreact",
						"vue",
						"svelte",
					},
				},

				lua_ls = {},
				pyright = {},
				ltex = {},
				jsonls = {},
				clangd = {},
				gopls = {},
				qmlls = {},

				rust_analyzer = {
					procMacro = {
						enable = false,
					},
					cargo = {
						allFeatures = false,
						buildScripts = {
							enable = false,
						},
					},
					checkOnSave = false,
					diagnostics = {
						enable = false,
					},
					inlayHints = {
						enable = false,
					},
				},
			}

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp_lsp.default_capabilities(capabilities)
			end

			local on_attach = function(_, bufnr)
				local opts = {
					noremap = true,
					silent = true,
					buffer = bufnr,
				}

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end

			vim.lsp.config("*", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.diagnostic.config({
				virtual_text = true,
			})

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end
		end,
	},
}
