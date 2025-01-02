return {
	"snacks.nvim",
	event = "VimEnter",
	opts = {
		dashboard = {

			-- Formats
			formats = {
				key = function(item)
					return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
				end,

				-- Change header color
				header = { hl = "icon" },
			},

			preset = {
				-- Keymaps
				keys = {
					{
						icon = " ",
						key = "s",
						desc = "Search File",
						action = ":lua Snacks.dashboard.pick('files')",
					},
					{
						icon = " ",
						key = "g",
						desc = "Search Word",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = "󰱼 ",
						key = "r",
						desc = "Search Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "n",
						desc = "New File",
						action = ":ene | startinsert",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{
						icon = " ",
						key = "b",
						desc = "Restore Session",
						section = "session",
					},
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{
						icon = " ",
						key = "q",
						desc = "Quit",
						action = ":qa",
					},
				},
			},

			-- Define sections
			sections = {
				{ section = "header" },

				{
					section = "keys",
					gap = 1,
					padding = 5,
				},

				{
					icon = "",
					title = "Recent Files",
					section = "recent_files",
					indent = 2,
					padding = 2,
				},

				{
					icon = " ",
					title = "Projects",
					section = "projects",
					indent = 2,
					padding = 2,
				},

				{ section = "startup" },
			},
		},
	},
}
