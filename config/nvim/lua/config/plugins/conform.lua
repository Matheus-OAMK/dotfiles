return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			python = { "ruff_format" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
		},

		-- Set this to change the default values when calling conform.format()
		-- This will also affect the default values for format_on_save/format_after_save
		default_format_opts = {
			lsp_format = "fallback",
			async = false,
			quiet = false,
			timeout_ms = 1000,
		},

		format_on_save = {},
	},

	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({
					timeout_ms = 3000,
				})
			end,
			mode = { "n", "x" },
			desc = "Format file or range (in visual mode)",
		},

		{
			"<leader>lF",
			function()
				require("conform").format({
					formatters = { "injected" },
					timeout_ms = 3000,
				})
			end,
			mode = { "n", "x" },
			desc = "Format Injected Langs",
		},
	},
}
