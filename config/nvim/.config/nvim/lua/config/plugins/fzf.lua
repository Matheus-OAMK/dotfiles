return {
	"ibhagwan/fzf-lua",
	-- event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	-- event = "VeryLazy",
	dependencies = {
		"nvim-mini/mini.icons",
		"folke/snacks.nvim",
	},
	opts = function()
		local fzf = require("fzf-lua")
		local config = fzf.config
		local actions = fzf.actions

		-- Quickfix
		config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"

		-- Open selected fzf-lua results in Trouble with ctrl-t
		config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open

		-- Register fzf-lua to be the handler for vim.ui.select
		-- Optionally pass a custom ui_select override from opts
		fzf.register_ui_select({
			winopts = {
				height = 0.6,
				width = 0.7,
				preview = {
					layout = "vertical", -- can be "vertical", "horizontal", "flex"
				},
			},
		})

		return {
			"default",
			defaults = {
				formatter = "path.dirname_first",
				cwd_prompt = true,
			},
			fzf_colors = true,
			winopts = {
				height = 0.9,
				width = 0.9,
				preview = {
					layout = "flex", -- can be "vertical", "horizontal", "flex"
				},
			},
			files = {
				file_icons = "mini",
				git_icons = true,
				-- cwd_prompt = true,
				cwd_prompt_shorten_len = 40, -- shorten prompt beyond this length
				-- cwd_header = true,
				-- fd_opts = [[--color=never --type f --type l --exclude .git --exclude node_modules]],
				hidden = true, -- show hidden files
				follow = true,
				no_ignore = false, -- respect .gitignore
				formatter = "path.filename_first",
				actions = {
					["alt-i"] = actions.toggle_ignore,
					["alt-h"] = actions.toggle_hidden,
				},
			},
			buffers = {
				formatter = "path.filename_first", -- ← Telescope-style truncation
				path_shorten = true,
			},

			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 -e",
				hidden = true, -- show hidden by default
				follow = true, -- follow symlinks by default
				no_ignore = false, -- respect ".gitignore"  by default
				actions = {
					["alt-i"] = actions.toggle_ignore,
					["alt-h"] = actions.toggle_hidden,
				},
			},
		}
	end,
	keys = function()
		local fzf = require("fzf-lua")

		local function map(lhs, fn, desc)
			return { lhs, fn, mode = "n", desc = desc }
		end

		return {

			-- ***** Git *****
			map("<leader>gc", fzf.git_bcommits, "[G]it [C]ommits"),
			map("<leader>gd", fzf.git_diff, "[G]it [D]iff (files)"),
			map("<leader>gl", fzf.git_commits, "[G]it Commit [L]og"),
			map("<leader>gs", fzf.git_status, "[G]it [S]tatus"),
			map("<leader>gS", fzf.git_stash, "[G]it [S]tash"),

			-- ***** Find *****
			map("<leader><leader>", fzf.buffers, "[ ] Find existing buffers"),
			map("<leader>fr", fzf.oldfiles, "[F]ind [R]ecent Files"),

			map("<leader>fR", function()
				fzf.oldfiles({ cwd = vim.uv.cwd() })
			end, "[F]ind [R]ecent Files (cwd)"),

			map("<leader>fF", fzf.files, "[S]earch [F]iles (cwd)"),

			map("<leader>ff", function()
				fzf.files({ cwd = MyUtils.root.get() })
			end, "[F]ind [F]iles (root)"),

			map("<leader>fn", function()
				fzf.files({ cwd = vim.fn.stdpath("config") })
			end, "[F]ind [N]eovim Config"),

			-- ***** Search *****
			map("<leader>sh", fzf.help_tags, "[S]earch [H]elp Pages"),
			map("<leader>sk", fzf.keymaps, "[S]earch [K]eymaps"),
			map("<leader>sr", fzf.resume, "[S]earch [R]esume"),
			map("<leader>sp", fzf.builtin, "[S]earch Select [P]icker"),
			map("<leader>sq", fzf.quickfix, "[S]earch [Q]uick Fix"),

			map("<leader>sg", function()
				fzf.live_grep({ cwd = MyUtils.root.get() })
			end, "[S]earch by [G]rep (root)"),

			map("<leader>sG", function()
				fzf.live_grep()
			end, "[S]earch by [G]rep (cwd)"),

			map("<leader>sW", fzf.grep_cword, "[S]earch Current [W]ord (cwd)"),

			map("<leader>sw", function()
				fzf.live_grep({ cwd = MyUtils.root.get() })
			end, "[S]earch Current [W]ord (root)"),

			map("<leader>/", function()
				fzf.blines({ previewer = false })
			end, "[/] Search in current buffer"),

			map("<leader>s/", function()
				fzf.lines()
			end, "[S]earch [/] in Open Buffers"),
		}
	end,
}
