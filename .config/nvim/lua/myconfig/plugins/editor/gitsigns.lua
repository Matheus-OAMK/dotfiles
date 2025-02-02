return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},

		config = function(_, opts)
			local gitsigns = require("gitsigns")

			gitsigns.setup({

				on_attach = function(buffnr)
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "Jump to the next hunk" })

					map("n", "[h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "Jump to the previous hunk" })

					map("n", "]H", function()
						gitsigns.nav_hunk("last")
					end, { desc = "Jump to last Hunk" })
					map("n", "[H", function()
						gitsigns.nav_hunk("first")
					end, { desc = "Jump to first Hunk" })

					-- Actions
					map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage current hunk" })
					map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset current hunk" })
					map("v", "<leader>ghs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage selected hunk" })
					map("v", "<leader>ghr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset selected hunk" })
					map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Stage entire buffer" })
					map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Undo last staged hunk" })
					map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Reset entire buffer" })
					map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Preview current hunk" })
					map("n", "<leader>ghb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "Show full blame for line" })
					map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
					map("n", "<leader>ghd", gitsigns.diffthis, { desc = "Show diff of current file" })
					map("n", "<leader>ghD", function()
						gitsigns.diffthis("~")
					end, { desc = "Show diff against previous commit" })
					map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Toggle deleted lines" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk as text object" })
				end,
			})
		end,
	},
}
