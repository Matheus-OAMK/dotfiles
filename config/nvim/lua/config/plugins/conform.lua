local ox_markers = {
	".oxlintrc.json",
	".oxlintrc.jsonc",
	"oxlint.config.ts",
	".oxfmtrc.json",
	".oxfmtrc.jsonc",
	"oxfmt.config.ts",
}

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			python = { "ruff_format" },
			javascript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			typescript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			json = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			jsonc = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			yaml = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			markdown = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			css = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			scss = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
			html = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
		},

		formatters = {
			oxfmt = {
				condition = function(_, ctx)
					return vim.fs.find(ox_markers, { path = ctx.dirname, upward = true })[1] ~= nil
				end,
			},
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
