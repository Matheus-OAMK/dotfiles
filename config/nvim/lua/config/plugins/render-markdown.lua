return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		code = {
			sign = false,
			border = "thin",
			right_pad = 4,
			width = "block",
			language_border = " ",
			language_left = "",
			language_right = "",
		},
		heading = {
			sign = true,
			icons = { "󰼏 ", "󰎨 ", "󰎫 ", "󰎲 ", "󰎯 ", "󰎴 " },
			backgrounds = {},
		},
		dash = {
			enabled = false,
			width = 15,
			highlight = "",
		},
	},
	ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
	config = function(_, opts)
		require("render-markdown").setup(opts)
		Snacks.toggle({
			name = "Render Markdown",
			get = require("render-markdown").get,
			set = require("render-markdown").set,
		}):map("<leader>um")
	end,
}
