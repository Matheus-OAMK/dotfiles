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
vim.opt.mousemoveevent = true

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

-- Save undo history
vim.opt.undofile = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- enable smart
vim.opt.breakindent = true

-- disable netrw [recommended for nvim-tree]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable smooth scrolling
vim.opt.smoothscroll = true

vim.opt.foldlevel = 99 -- Large number so folds are open by default
vim.opt.foldexpr = "v:lua.MyConfig.foldexpr()" -- Function to fold using treesitter
vim.opt.foldmethod = "expr" -- Change fold method to expression
vim.opt.foldtext = ""

vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
