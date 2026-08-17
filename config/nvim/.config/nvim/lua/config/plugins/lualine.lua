return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local opts = {
				options = {
					-- theme = "palenight",
					-- theme = "moonfly",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = { statusline = { "snacks_dashboard", "dashboard" } },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diagnostics" },
					lualine_c = {
						{
							"filetype",
							colored = true,
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},
						{
							"filename",
							padding = { left = 0, right = 1 },
						},
					},
					lualine_x = { "diff" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				extensions = { "neo-tree", "lazy", "fzf" },
			}

			if vim.g.trouble_lualine ~= false then
				local ok, trouble = pcall(require, "trouble")
				if ok then
					local symbols = trouble.statusline({
						mode = "symbols",
						groups = {},
						title = false,
						filter = { range = true },
						format = "{kind_icon}{symbol.name:Normal}",
						hl_group = "lualine_c_normal",
					})

					table.insert(opts.sections.lualine_c, {
						symbols.get,
						cond = function()
							return vim.b.trouble_lualine ~= false and symbols.has()
						end,
					})
				end
			end

			return opts
		end,
	},
}
