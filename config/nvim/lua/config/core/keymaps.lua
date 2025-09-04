local opts = { noremap = true, silent = true}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable moving of multiple lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Allows to move multiple highlighted lines" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Allows to move multiple highlighted lines" })

-- Center cursors on search and vertical movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after vertical movements" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center cursor after vertical movements" })

-- Center cursor when going to previous or next search
vim.keymap.set("n", "n", "nzzzv", { desc = "Center cursor after searching" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Center cursor after searching" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" }) vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- When indenting in visual mode maintain visual
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

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


-- Window management
vim.keymap.set("n", "<leader>Sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>Sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>Se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>Sx", "<cmd>close<CR>", { desc = "Close current split" })
-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
