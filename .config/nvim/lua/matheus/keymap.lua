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

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
