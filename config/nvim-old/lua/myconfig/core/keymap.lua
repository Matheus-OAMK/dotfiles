vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window management
vim.keymap.set("n", "<leader>Sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>Sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>Se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>Sx", "<cmd>close<CR>", { desc = "Close current split" })

-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })

-- Center cursors on search and vertical movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after vertical movements" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center cursor after vertical movements" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Center cursor after searching" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Center cursor after searching" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Enable moving of multiple lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Allows to move multiple highlighted lines" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Allows to move multiple highlighted lines" })

-- Tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Dont save copy when replacing
vim.keymap.set("n", "x", '"_x')

-- Clear search highlight with <Esc>, and keep default behaviour
vim.keymap.set("n", "<Esc>", function()
	vim.cmd("nohlsearch") -- Clear search highlights
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { silent = true })

-- Commenting
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous [D]iagnostic message" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next [D]iagnostic message" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
