return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			transparent_background = true,
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			float = {
				transparent = true,
				solid = false,
			},
			integrations = {
				which_key = true,
				snacks = true,
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
		opts = {
			transparent_bg = true,
			italic_comment = true,
		},
	},
	{
		"Shatur/neovim-ayu",
		lazy = true,
	},
	{
		"sainnhe/everforest",
		lazy = true,
		init = function()
			vim.g.everforest_transparent_background = 2
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
		opts = {
			transparent_mode = true,
		},
	},
	{
		"sainnhe/gruvbox-material",
		lazy = true,
		init = function()
			vim.g.gruvbox_material_transparent_background = 2
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = {
			transparent = true,
		},
	},
	{
		"gbprod/nord.nvim",
		lazy = true,
		opts = {
			transparent = true,
		},
	},
	{
		"loctvl842/monokai-pro.nvim",
		lazy = true,
		opts = {
			transparent_background = true,
		},
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		opts = {
			styles = {
				transparency = true,
			},
		},
	},
	{
		"maxmx03/solarized.nvim",
		lazy = true,
		opts = {
			transparent = {
				enabled = true,
			},
		},
	},
	{
		"nvim-mini/mini.base16",
		lazy = true,
	},
}
