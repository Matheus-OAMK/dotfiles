return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		-- Autoinstall languages that are not installed
		auto_install = true,
		ensure_installed = {
      "c",
      "rust",
      "python",
      "go",
      "javascript",
      "jsdoc",
      "typescript",
      "tsx",
      "bash",
			"html",
      "css",
			"lua",
			"luadoc",
      "vim",
      "vimdoc",
			"markdown",
			"markdown_inline",
			"toml",
      "yaml",
      "json",
      "dockerfile",
      "gitignore",
      "gitcommit",
      "diff",
      "sql",
      "tmux",
		},
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = false
		},
		indent = { enable = true  },
	},
	config = function(_, opts)
		require("nvim-treesitter.install").prefer_git = true
		require("nvim-treesitter.configs").setup(opts)
	end,
}
