return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		opts = {
			animate = { enabled = false }, -- global animation setting
			icons = {
				closed = "",
				open = "",
			},
			right = {
				{
					ft = "copilot-chat",
					title = "Copilot Chat",
					size = { width = 50 },
					pinned = true,
				},
			},
		},
	},
}
