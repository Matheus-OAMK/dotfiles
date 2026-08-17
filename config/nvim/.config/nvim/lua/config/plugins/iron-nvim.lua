return {
	"Vigemus/iron.nvim",
	config = function()
		require("iron.core").setup({
			config = {
				-- Whether a repl should be discarded or not
				scratch_repl = true,
				-- Define REPL commands for specific filetypes
				repl_definition = {
					sh = {
						command = { "zsh" },
					},
					python = {
						-- command = { "ipython", "--no-autoindent" },
						-- command = { "python3" },
						command = { "uv", "run", "--with", "ipython", "ipython", "--no-autoindent" },

						block_dividers = { "# %%", "#%%" },
						env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
					},
					lua = {
						command = { "lua" },
					},
				},
				-- Configure how the REPL window opens
				repl_open_cmd = "vertical botright 40split",
			},
			-- Keybindings for iron.nvim
			keymaps = {
				send_motion = "<leader>rc",
				visual_send = "<leader>rc",
				send_file = "<leader>rf",
				send_line = "<leader>rl",
				send_mark = "<leader>rm",
				mark_motion = "<leader>mc",
				mark_visual = "<leader>mc",
				remove_mark = "<leader>md",
				cr = "<leader>r<cr>",
				interrupt = "<leader>r<space>",
				exit = "<leader>rq",
				clear = "<leader>rcl",
			},
		})
	end,
	keys = {
		{ "<leader>ro", "<cmd>IronRepl<cr>", desc = "Start REPL" },
		{ "<leader>rr", "<cmd>IronRestart<cr>", desc = "Restart REPL" },
		{ "<leader>rf", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
		{ "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide REPL" },
	},
}
