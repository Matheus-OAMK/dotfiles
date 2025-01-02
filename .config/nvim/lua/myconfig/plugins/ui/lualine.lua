return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			theme = "dracula",
		},

		extensions = { "neo-tree", "lazy", "fzf" },
	},
}
