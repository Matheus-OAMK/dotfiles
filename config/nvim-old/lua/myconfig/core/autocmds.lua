-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Deletes ^M chars when pasting from OS
-- vim.api.nvim_create_autocmd("TextChanged", {
-- 	desc = "Removes blank whitespace characters ^M when pasting from OS",
-- 	group = vim.api.nvim_create_augroup("clear-blank-whitespaces-chars", { clear = true }),
-- 	callback = function()
-- 		local save_cursor = vim.fn.getpos(".")
-- 		vim.cmd("silent! %s/\\r//g")
-- 		vim.fn.setpos(".", save_cursor)
-- 	end,
-- })

-- Exist insert mode with esc in REPL
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("TerminalMappings", { clear = true }),
	callback = function()
		-- Make Esc behave like <C-\><C-n> in terminal buffers
		vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = true, silent = true })
	end,
})
