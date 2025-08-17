return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			spec = {
				{
					mode = { "n", "v" },
					{ "<leader>t", group = "tabs" },
					{ "<leader>c", group = "code" },
					{ "<leader>d", group = "debug" },
					{ "<leader>dp", group = "profiler" },
					{ "<leader>f", group = "explorer" },
					{ "<leader>g", group = "git" },
					{ "<leader>gh", group = "hunks" },
					{ "<leader>s", group = "search" },
					{ "<leader>n", group = "notifications" },
					{ "<leader>r", group = "REPL" },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "ys", group = "surround" },
					{ "z", group = "fold" },
					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
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
