return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_by_name = {
					".git",
					".DS_STORE",
				},
				always_show = {
					".env",
				},
			},
		},
		window = {
			width = 35,
		},
		buffers = {
			follow_current_file = {
				enabled = true,
			},
		},
	},

	config = function(_, opts)
		require("neo-tree").setup(opts)

		-- Toggle Neotree
		vim.keymap.set("n", "<leader>no", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

		-- Focus on the current file in Neotree
		vim.keymap.set(
			"n",
			"<leader>nf",
			"<cmd>Neotree toggle reveal<CR>",
			{ desc = "Reveal current file in file explorer" }
		)

		-- Open neotree for buffers
		vim.keymap.set("n", "<leader>nb", "<cmd>Neotree toggle buffers<CR>", { desc = "Toggle file explorer" })
	end,
}
