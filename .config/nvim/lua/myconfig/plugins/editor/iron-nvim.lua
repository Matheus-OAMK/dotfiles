return {
	"Vigemus/iron.nvim",
	config = function()
		require("iron.core").setup({
			config = {
				-- Define REPL commands for specific filetypes
				repl_definition = {
					python = {
						command = { "ipython", "--no-autoindent" },
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
