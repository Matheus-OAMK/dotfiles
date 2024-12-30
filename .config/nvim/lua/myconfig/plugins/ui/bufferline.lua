return {
	"akinsho/bufferline.nvim",
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					highlight = "Directory",
					separator = true, -- use a "true" to enable the default, or set your own character
					text_align = "left",
				},
			},
		},
	},
}
