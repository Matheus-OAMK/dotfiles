return {
	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },

	-- icons
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},

		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 10000,
		lazy = false,
		opts = {},
	},

	{
		"snacks.nvim",
		opts = {
			input = { enabled = true },
			notifier = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = false },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		-- stylua: ignore
		keys = {
		  { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
		  { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		},
	},
}
