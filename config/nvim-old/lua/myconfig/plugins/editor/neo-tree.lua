return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = {
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},

	keys = {

		{
			"<leader>fe",
			function()
				require("neo-tree.command").execute({ toggle = true })
			end,
			desc = "Explorer NeoTree (Root Dir)",
		},

		{
			"<leader>fb",
			function()
				require("neo-tree.command").execute({ source = "buffers", toggle = true })
			end,
			desc = "Buffer Explorer",
		},

		{
			"<leader>ff",
			function()
				require("neo-tree.command").execute({ toggle = true, reveal = true })
			end,
			desc = "Reveal current file in file explorer",
		},
	},

	deactivate = function()
		vim.cmd([[Neotree close]])
	end,

	init = function()
		-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
		-- because `cwd` is not set up properly.
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Neo-tree with directory",
			once = true,
			callback = function()
				if package.loaded["neo-tree"] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("neo-tree")
					end
				end
			end,
		})
	end,

	opts = {
		sources = { "diagnostics", "filesystem", "buffers", "git_status" },
		enable_diagnostics = true,
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
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

		default_component_configs = {
			indent = {
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
			},
			git_status = {
				symbols = {
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
		},
	},

	config = function(_, opts)
		require("neo-tree").setup(opts)
	end,
}
