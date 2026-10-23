-- Snacks picker: files, grep, buffers, git, and the rest (replaces fzf-lua).
-- Explorer settings stay in snacks.lua; lazy.nvim merges both specs.
local function map(lhs, fn, desc, mode)
	return { lhs, fn, mode = mode or "n", desc = desc }
end

return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			show_empty = true, -- open the picker even when there are no results
			-- 90% of the screen, like fzf-lua. Only the presets the picker switches between
			-- (default when wide, vertical below 120 columns), so ivy, select and the explorer keep their size
			layouts = {
				default = { layout = { width = 0.9, height = 0.9 } },
				vertical = { layout = { width = 0.9, height = 0.9 } },
			},
			formatters = {
				file = { filename_first = true },
			},
			-- Open selected (or all) results in Trouble with ctrl-t
			actions = {
				trouble_open = function(...)
					return require("trouble.sources.snacks").actions.trouble_open.action(...)
				end,
			},
			win = {
				input = { keys = { ["<c-t>"] = { "trouble_open", mode = { "n", "i" } } } },
				list = { keys = { ["<c-t>"] = "trouble_open" } },
			},
			sources = {
				files = { hidden = true, follow = true },
				grep = { hidden = true, follow = true },
				grep_word = { hidden = true, follow = true },
			},
		},
	},
	keys = {
		-- ***** Git *****
		map("<leader>gc", function()
			Snacks.picker.git_log_file()
		end, "[G]it [C]ommits"),
		map("<leader>gd", function()
			Snacks.picker.git_diff()
		end, "[G]it [D]iff (files)"),
		map("<leader>gl", function()
			Snacks.picker.git_log()
		end, "[G]it Commit [L]og"),
		map("<leader>gs", function()
			Snacks.picker.git_status()
		end, "[G]it [S]tatus"),
		map("<leader>gS", function()
			Snacks.picker.git_stash()
		end, "[G]it [S]tash"),
		map("<leader>gb", function()
			Snacks.picker.git_branches()
		end, "[G]it [B]ranches"),

		-- ***** Find *****
		map("<leader><leader>", function()
			Snacks.picker.buffers()
		end, "[ ] Find existing buffers"),
		map("<leader>fr", function()
			Snacks.picker.recent()
		end, "[F]ind [R]ecent Files"),
		map("<leader>fR", function()
			Snacks.picker.recent({ filter = { cwd = true } })
		end, "[F]ind [R]ecent Files (cwd)"),
		map("<leader>fF", function()
			Snacks.picker.files()
		end, "[S]earch [F]iles (cwd)"),
		map("<leader>ff", function()
			Snacks.picker.files({ cwd = MyUtils.root.get() })
		end, "[F]ind [F]iles (root)"),
		map("<leader>fn", function()
			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end, "[F]ind [N]eovim Config"),

		-- ***** Search *****
		map("<leader>sh", function()
			Snacks.picker.help()
		end, "[S]earch [H]elp Pages"),
		map("<leader>sk", function()
			Snacks.picker.keymaps()
		end, "[S]earch [K]eymaps"),
		map("<leader>sr", function()
			Snacks.picker.resume()
		end, "[S]earch [R]esume"),
		map("<leader>sp", function()
			Snacks.picker.pickers()
		end, "[S]earch Select [P]icker"),
		map("<leader>sq", function()
			Snacks.picker.qflist()
		end, "[S]earch [Q]uick Fix"),
		map("<leader>su", function()
			Snacks.picker.undo()
		end, "[S]earch [U]ndo History"),
		map("<leader>s:", function()
			Snacks.picker.command_history()
		end, "[S]earch [:] Command History"),
		map("<leader>sn", function()
			Snacks.picker.notifications()
		end, "[S]earch [N]otifications"),

		map("<leader>sg", function()
			Snacks.picker.grep({ cwd = MyUtils.root.get() })
		end, "[S]earch by [G]rep (root)"),
		map("<leader>sG", function()
			Snacks.picker.grep()
		end, "[S]earch by [G]rep (cwd)"),
		map("<leader>sW", function()
			Snacks.picker.grep_word()
		end, "[S]earch Current [W]ord (cwd)", { "n", "x" }),
		map("<leader>sw", function()
			Snacks.picker.grep_word({ cwd = MyUtils.root.get() })
		end, "[S]earch Current [W]ord (root)", { "n", "x" }),

		map("<leader>/", function()
			Snacks.picker.lines()
		end, "[/] Search in current buffer"),
		map("<leader>s/", function()
			Snacks.picker.grep_buffers()
		end, "[S]earch [/] in Open Buffers"),
	},
}
