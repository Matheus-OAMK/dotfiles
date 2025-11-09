return {
  {
    'nvim-mini/mini.surround',
    version = false ,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      -- Normal mode
      { "sa", desc = "Add Surround", mode = { "n", "v" } },
      { "sd", desc = "Delete Surround", mode = "n" },
      { "sf", desc = "Find Surround", mode = "n" },
      { "sF", desc = "Find Surround Left", mode = "n" },
      { "sh", desc = "Highlight Surround", mode = "n" },
      { "sr", desc = "Replace Surround", mode = "n" },

    },

    opts = {}, -- default config
  },



	-- icons
	{
		"nvim-mini/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},

		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
}
