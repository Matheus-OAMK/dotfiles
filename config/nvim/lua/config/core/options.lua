-- Sync clipboard with OS
vim.opt.clipboard = "unnamedplus"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Save undo history
vim.opt.undofile = true

-- Tab width
vim.opt.tabstop = 2       -- render a tab (\t) as 2 spaces
vim.opt.shiftwidth = 2    -- indent width for >>, <<, and auto-indent
vim.opt.softtabstop = 2   -- Tab key inserts 2 spaces in insert mode
vim.opt.expandtab = true  -- convert tabs to spaces
-- Preserves indentation when inserting new lines
vim.opt.autoindent = true
vim.opt.smartindent = true
-- When a line wraps the indentation remains the same for the following lines
vim.opt.breakindent = true

-- Better colours
vim.opt.termguicolors = true


-- Enable mouse
vim.opt.mouse = "a"
vim.opt.mousemoveevent = true

-- Hide mode since lualine shows it already
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Set highlight on search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Faster updatetime
vim.opt.updatetime = 100

vim.opt.foldtext = ""
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.opt.foldlevel = 99 -- Large number so folds are open by default
