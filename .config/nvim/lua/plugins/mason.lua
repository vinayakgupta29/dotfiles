-- plugins/mason.lua
return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
				"html",
				"cssls",
				"ts_ls",
				"emmet_ls",
				"lua_ls",
				"pyright",
				"ltex",
				"jsonls",
				"clangd",
				"gopls",
				"qmlls",
				"rust_analyzer",
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
				"stylua",
				"black",
				"prettier",
			},
			run_on_start = true,
		},
	},
}
