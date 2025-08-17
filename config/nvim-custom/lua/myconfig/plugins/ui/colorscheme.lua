-- return {
--   { "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000,
--     opts = {
--       flavour = "mocha",
--       transparent_background = true,
--       no_italic = true,
--     },
--
--
--     config = function(_, opts)
--       require("catppuccin").setup(opts)
--       vim.cmd.colorscheme "catppuccin"
--       vim.cmd.hi 'Comment gui=none'
--     end
--   }
-- }

return {
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"folke/tokyonight.nvim",
	lazy = false, -- Load before everything else
	priority = 1000,
	opts = {
		transparent = true,
		style = "storm",
		styles = {
			floats = "transparent",
			sidebars = "transparent",
		},
		on_colors = function(colors)
			colors.bg_visual = colors.blue7 -- Color highlight when in telescope and other windows
			colors.fg_gutter = colors.comment -- numbers in the gutter and also scope lines
		end,
		on_highlights = function(hl, c)
			hl.TabLineFill = { bg = "none" }
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)

		vim.cmd.colorscheme("tokyonight")
	end,
}
