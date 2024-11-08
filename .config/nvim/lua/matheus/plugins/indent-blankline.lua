return {
	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable lukas-reineke/indent-blankline.nvim
		-- See :help ibl
		main = "ibl",
    commit = "65e20ab94a26d0e14acac5049b8641336819dfc7",
		opts = {
			indent = {
				char = "┆",
			},
			scope = {
				-- highlight = "IndentBlanklineContextChar",
			},
		},

		config = function(_, opts)
			-- Register a hook to set the highlight groups whenever the colorscheme changes
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				-- Set the regular indent character color
				vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#F5C2E7" })
				-- Set the scope highlight color
				vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#89b4fa" })
			end)

			require("ibl").setup(opts)
		end,
	},
}
