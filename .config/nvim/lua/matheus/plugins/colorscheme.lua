-- /nvim/lua/matheus/plugins/colorscheme.lua

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

return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"folke/tokyonight.nvim",
	priority = 1000,
	opts = {
		transparent = true,
		style = "storm",
		styles = {
			floats = "transparent",
			sidebars = "transparent",
		},
		on_colors = function(colors)
			colors.bg_visual = colors.blue7
			colors.fg_gutter = colors.comment
			-- colors.bg_highlight = "#2E3C5A"
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)

		vim.cmd.colorscheme("tokyonight")

		-- You can configure highlights by doing something like:
		-- vim.cmd.hi 'Comment gui=none'
	end,
}
