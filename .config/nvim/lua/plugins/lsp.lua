return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim'
	},
	config = function()
		require("neodev").setup({})
		require("neoconf").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
			},
			automatic_installation = true
		})

		require("mason-lspconfig").setup_handlers {
			function (server_name)
				require("lspconfig")[server_name].setup {}
			end
		}
	end
}
