-- plugins/fzf-lua.lua
return {
	"ibhagwan/fzf-lua",

	dependencies = {
		"nvim-tree/nvim-web-devicons", -- optional, for file icons
	},

	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				preview = {
					layout = "flex", -- can be "vertical", "horizontal", "flex"
				},
			},
			files = {
				hidden = true, -- show hidden files
				fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
			},
			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
			},
			keymap = {
				builtin = {
					["<C-j>"] = "down", -- move down in results
					["<C-k>"] = "up", -- move up in results
					-- ["<C-q>"] = "toggle-all+accept", -- send all to quickfix
				},
			},
		})

		-- Keymaps (mapped as close as possible to Telescope)
		vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", fzf.builtin, { desc = "[S]earch [S]elect Picker" })
		vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Find existing buffers" })

		vim.keymap.set("n", "<leader>/", function()
			fzf.blines()
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			fzf.live_grep_glob({
				cwd = vim.uv.cwd(),
				rg_opts = "--no-heading --with-filename --line-number --column --smart-case --color=always",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching Neovim config files
		vim.keymap.set("n", "<leader>sn", function()
			fzf.files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
