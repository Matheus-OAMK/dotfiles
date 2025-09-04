return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
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
		},
    keys = function()
      local fzf = require("fzf-lua")

      local function map(lhs, fn, desc)
        return { lhs, fn, mode = "n", desc = desc }
      end

      return {
        map("<leader>sh", fzf.help_tags,         "[S]earch [H]elp"),
        map("<leader>sk", fzf.keymaps,           "[S]earch [K]eymaps"),
        map("<leader>sf", fzf.files,             "[S]earch [F]iles"),
        map("<leader>ss", fzf.builtin,           "[S]earch [S]elect Picker"),
        map("<leader>sw", fzf.grep_cword,        "[S]earch current [W]ord"),
        map("<leader>sg", fzf.live_grep,         "[S]earch by [G]rep"),
        map("<leader>sd", fzf.diagnostics_document, "[S]earch [D]iagnostics"),
        map("<leader>sr", fzf.resume,            "[S]earch [R]esume"),
        map("<leader>s.", fzf.oldfiles,          '[S]earch Recent Files ("." for repeat)'),
        map("<leader><leader>", fzf.buffers,     "[ ] Find existing buffers"),

        -- your new ones
        map("<leader>/", function()
          fzf.blines({previewer = false})
        end, "[/] Fuzzily search in current buffer"),

        map("<leader>s/", function()
          fzf.live_grep({
            cwd = vim.loop.cwd(),
            rg_opts = "--no-heading --with-filename --line-number --column --smart-case --color=always",
          })
        end, "[S]earch [/] in Open Files"),

        map("<leader>sn", function()
          fzf.files({ cwd = vim.fn.stdpath("config") })
        end, "[S]earch [N]eovim config"),
      }
    end,
  },
}
