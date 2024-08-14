-- Tab width
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Faster updatetime
vim.opt.updatetime = 300

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse
vim.opt.mouse = "a"

-- Sync clipboard with OS
vim.opt.clipboard = "unnamedplus"
vim.g.have_nerd_font = true

-- Hide mode since lualine shows it already
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Better colours
vim.opt.termguicolors = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save undo history
vim.opt.undofile = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- enable smart indent
vim.opt.breakindent = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- disable netrw [recommended for nvim-tree]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Deletes ^M chars when pasting from OS
vim.api.nvim_create_autocmd("TextChanged", {
	desc = "Removes blank whitespace characters ^M when pasting from OS",
	group = vim.api.nvim_create_augroup("clear-blank-whitespaces-chars", { clear = true }),
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd("silent! %s/\\r//g")
		vim.fn.setpos(".", save_cursor)
	end,
})
