-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- open help & man in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help,man",
	command = "wincmd L",
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- vim.option.confirm = true to be default to Cancel instead of Yes
vim.api.nvim_create_user_command("QCancelDefault", function()
	if not vim.bo.modified then
		vim.cmd("quit")
		return
	end
	local choice = vim.fn.confirm("Save changes before quitting?", "&Yes\n&No\n&Cancel", 3)
	if choice == 1 then
		vim.cmd("write")
		vim.cmd("quit")
	elseif choice == 2 then
		vim.cmd("quit!")
	end
end, {})

-- vim.option.confirm = true to be default to Cancel instead of Yes
vim.api.nvim_create_user_command("QACancelDefault", function()
	local has_modified = false
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and vim.bo[buf].modified then
			has_modified = true
			break
		end
	end
	if not has_modified then
		vim.cmd("qa")
		return
	end
	local choice = vim.fn.confirm("Save all changes before quitting?", "&Yes\n&No\n&Cancel", 3)
	if choice == 1 then
		vim.cmd("wall")
		vim.cmd("qa")
	elseif choice == 2 then
		vim.cmd("qa!")
	end
end, {})

-- vim.option.confirm = true to be default to Cancel instead of Yes
vim.cmd([[cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'QCancelDefault' : 'q']])
vim.cmd([[cnoreabbrev <expr> qa getcmdtype() == ':' && getcmdline() == 'qa' ? 'QACancelDefault' : 'qa']])
