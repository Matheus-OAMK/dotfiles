return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			triggers = {
				{ "s", mode = { "n", "x" } }, -- make 's' a which-key trigger
				{ "<auto>", mode = "nxso" },
			},
			spec = {
				{
					mode = { "n", "x" },
					-- { "<leader>t", group = "tabs" },
					{ "<leader>S", group = "Split" },
					{ "<leader>c", group = "code" },
					{ "<leader>f", group = "file/find" },
					{ "<leader>g", group = "git" },
					{ "<leader>gh", group = "hunks" },
					{ "<leader>s", group = "Search" },
					{ "<leader>q", group = "session" },
					{ "<leader>u", group = "ui/toggles" },
					{ "<leader>n", group = "notifications" },
					{ "<leader>x", group = "diagnostics/quickfix" },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "s", group = "surround" },
					{ "z", group = "fold" },

					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
						end,
					},

					{
						"<leader>w",
						group = "windows",
						proxy = "<c-w>",
						expand = function()
							return require("which-key.extras").expand.win()
						end,
					},
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
