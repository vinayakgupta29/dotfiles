-- plugins/tools.lua
return {
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
		},
	},
}
