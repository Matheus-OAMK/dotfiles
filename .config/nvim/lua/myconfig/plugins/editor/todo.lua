return {
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		opts = {},
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},

			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},

			-- Search
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },

			{ "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },

			-- Integration with trouble

			-- { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },

			-- {
			-- 	"<leader>xT",
			-- 	"<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
			-- 	desc = "Todo/Fix/Fixme (Trouble)",
			-- },
		},
	},
}
