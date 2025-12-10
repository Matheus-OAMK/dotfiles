-- Terminal Mappings
local function term_nav(dir)
	---@param self snacks.terminal
	return function(self)
		return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end

return {
	{
		"folke/snacks.nvim",
		dependencies = { "nvim-mini/mini.icons" }, -- Icons for explorer
		priority = 1000,
		lazy = false,
		opts = {

			-- Dashboard
			dashboard = {
				enabled = true,
				preset = {
					header = [[
                       ▓▓█      ▓▓▓▓            
                      ▓▓▓▓█▓▓▓▓▓█▓▓             
                      ▓▓█████████▓▒             
                     ▓███████████▒▒             
                     ▓█████████▓▓▒▒▒▒           
                    ▓▓▒▒▓▓▓███▓▓▓▒▒▒▒           
                  ▓██▓▒▒▓▓▓▓▓▓▓▒▒▒▒▒▓▓          
                 ▓▓▓█▓▒▒▒▒▓▓▓▓▒▒▒▒▒▓▓▓▓         
              ▒▒▒▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓        
   ██████    ▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓        
  ███████   ▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒       
  ██████   ▓▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒      
  █████████▓▒▒▒▒▒▒▓▓▓▓▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒▒      
   ████████▓▒▒▒▒▒▓▓▓▓▓▒▒▒█▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▒▒     
    ██████▓▒▒▒▒▒▓▓▓██▓▓▓▓██▓▓▓▓▓▒▒▒▒▒▒▒▒        
        ▒▒▒▒▒▒▒▓              ▓▓▒▒▒▒▒▒▒         
      ▒▒▒▒▒▒▓                    ▓▓▒▒▒▒░▒       
     ▓▓▓▓▓                         ▓▓▓▓▒▒▒▒▒    
                                      ▓█▓▓▓▒▒   
]],
				},
			},

			-- File Explorer
			explorer = {
				enabled = true,
				replace_netrw = true, -- Replace netrw with the snacks explorer
				trash = true, -- Use the system trash when deleting files
			},

			picker = {
				sources = {
					explorer = {
						hidden = true,
						ignored = true,
					},
				},
			},

			statuscolumn = { enabled = true },
			bigfile = { enabled = true },
			quickfile = { enabled = true },

			-- Ident Line
			indent = {
				enabled = true,
				indent = {
					char = "┆",
				},
				scope = {
					char = "┆",
				},
			},

			-- Notificaitons
			notifier = { enabled = true },

			-- Auto show LSP references and jump between them
			words = { enabled = true },

			-- Toggle things
			toggle = { enabled = true },

			-- Images
			image = {
				enabled = true,
			},

			-- Terminal
			terminal = {
				win = {
					keys = {
						nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
						nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
						nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
						nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
						hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = { "t", "n" } },
						hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = { "t", "n" } },
					},
				},
			},
		},

		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
					Snacks.toggle.indent():map("<leader>ug")
					Snacks.toggle.dim():map("<leader>uD")
				end,
			})
		end,

		keys = {
			-- Explorer
			{
				"<leader>fe",
				function()
					Snacks.explorer({ cwd = MyUtils.root.get() })
				end,
				desc = "Explorer Snacks (root dir)",
			},
			{
				"<leader>fE",
				function()
					Snacks.explorer({ ignored = true })
				end,
				desc = "Explorer Snacks (cwd)",
			},

			-- Notifier
			{
				"<leader>nh",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			-- Words
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
			-- Terminal
			{
				"<leader>fT",
				function()
					Snacks.terminal()
				end,
				desc = "Terminal (cwd)",
				mode = { "n" },
			},
			{
				"<c-/>",
				function()
					Snacks.terminal(nil, { cwd = MyUtils.root.get() })
				end,
				desc = "Terminal (Root Dir)",
				mode = { "n", "t" },
			},
		},
	},
}
