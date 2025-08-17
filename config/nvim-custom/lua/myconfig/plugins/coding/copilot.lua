return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",

		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
		},

		opts = {
			-- See Configuration section for options
			window = {
				layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
				width = 0.4, -- fractional width of parent, or absolute width in columns when > 1
				height = 0.4, -- fractional height of parent, or absolute height in rows when > 1
			},

			question_header = " User ", -- Header to use for user questions
			answer_header = "  Copilot ", -- Header to use for AI answers
		},

		keys = {
			{ "<leader>a", "", desc = "ai", mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
		},

		config = function(_, opts)
			local chat = require("CopilotChat")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)
		end,
	},
}
