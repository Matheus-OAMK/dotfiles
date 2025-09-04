return {
	{
		"mason-org/mason.nvim",
		-- lazy = false,
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- import mason
			local mason = require("mason")

			-- import mason-lspconfig
			local mason_lspconfig = require("mason-lspconfig")

			-- import mason-tool-installer
			local mason_tool_installer = require("mason-tool-installer")

			-- Setup mason
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_lspconfig.setup({
				automatic_enable = false,
			})

      -- If mason-lspconfig is installed, mason-tool-installer can accept lspconfig package names unless the integration is disabled.
			mason_tool_installer.setup({
				ensure_installed = {
          "lua_ls", -- Lua language server
          "stylua", -- lua formatter
					-- "ts_ls",
					-- "html",
					-- "cssls",
					-- "tailwindcss",
					-- "jsonls",
					-- "rust_analyzer",
					-- "pyright",
          "basedpyright",
					-- "prettier", -- prettier formatter
					"ruff",
					-- "eslint_d", -- javascript/typescript linter
					-- "solhint", -- solidity linter
				},
			})
		end,
	},
}
