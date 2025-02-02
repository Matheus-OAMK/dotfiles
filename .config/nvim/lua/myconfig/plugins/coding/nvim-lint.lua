return {
	-- "mfussenegger/nvim-lint",
	-- event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	--
	-- config = function()
	-- 	local lint = require("lint")
	--
	-- 	lint.linters_by_ft = {
	-- 		javascript = { "eslint_d" },
	-- 		javascriptreact = { "eslint_d" },
	-- 		typescript = { "eslint_d" },
	-- 		typescriptreact = { "eslint_d" },
	-- 		python = { "ruff" },
	-- 		solidity = { "solhint" },
	-- 	}
	--
	-- 	-- Custom lint function, similar to LazyVim
	-- 	local function custom_lint()
	-- 		-- Use nvim-lint's logic first:
	-- 		-- * checks if linters exist for the full filetype first
	-- 		-- * otherwise will split filetype by "." and add all those linters
	-- 		local names = lint._resolve_linter_by_ft(vim.bo.filetype)
	--
	-- 		-- Create a copy of the names table to avoid modifying the original.
	-- 		names = vim.list_extend({}, names)
	--
	-- 		-- Add fallback linters.
	-- 		if #names == 0 then
	-- 			vim.list_extend(names, lint.linters_by_ft["_"] or {})
	-- 		end
	--
	-- 		-- Add global linters.
	-- 		vim.list_extend(names, lint.linters_by_ft["*"] or {})
	--
	-- 		-- Filter out linters that don't exist or don't match the condition.
	-- 		local ctx = { filename = vim.api.nvim_buf_get_name(0) }
	-- 		ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
	-- 		names = vim.tbl_filter(function(name)
	-- 			local linter = lint.linters[name]
	-- 			return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
	-- 		end, names)
	--
	-- 		-- Run linters.
	-- 		if #names > 0 then
	-- 			lint.try_lint(names)
	-- 		end
	-- 	end
	--
	-- 	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	--
	-- 	-- Replace the linting callback with the custom lint function
	-- 	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	-- 		group = lint_augroup,
	-- 		callback = function()
	-- 			custom_lint()
	-- 		end,
	-- 	})
	--
	-- 	vim.keymap.set("n", "<leader>ll", function()
	-- 		custom_lint()
	-- 	end, { desc = "Trigger linting for the current file" })
	-- end,
}
