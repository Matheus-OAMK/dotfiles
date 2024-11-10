return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- import mason
			require("mason").setup()

			-- import mason-lspconfig
			local mason_lspconfig = require("mason-lspconfig")

			-- import mason-tool-installer
			local mason_tool_installer = require("mason-tool-installer")

			mason_lspconfig.setup({
				-- List ensured servers for mason to install
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"html",
					"cssls",
					"tailwindcss",
					"jsonls",
					"rust_analyzer",
					"pyright",
					"solidity_ls",
					"solidity_ls_nomicfoundation", -- Working better with linting
				},
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					-- "isort", -- python formatter
					-- "black", -- python formatter
					-- "pylint", -- python linter
					"eslint_d", -- javascript/typescript linter
					"solhint", -- solidity linter
				},
			})
		end,
	},
}
