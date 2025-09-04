return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	opts = {
		options = {

			diagnostics = "nvim_lsp",

			show_buffer_close_icons = false,

			indicator = {
				icon = "▎", -- this should be omitted if indicator style is not 'icon'
				style = "none",
			},

			diagnostics_indicator = function(_, _, diag)
				local icons = MyConfig.icons.diagnostics
				local ret = (diag.error and icons.Error .. diag.error .. " " or "")
					.. (diag.warning and icons.Warn .. diag.warning or "")
				return vim.trim(ret)
			end,

			separator_style = "thick",

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

	keys = {
		{ "<leader>bP", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		{ "<leader>bX", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
		{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Go to prev Buffer" },
		{ "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Go to next Buffer" },
	},
}
