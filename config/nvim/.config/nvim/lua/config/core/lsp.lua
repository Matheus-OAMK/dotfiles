-- ***** DIAGNOSTICS *****
-- Define sign icons for each severity
local signs = {
	[vim.diagnostic.severity.ERROR] = "󰅚 ",
	[vim.diagnostic.severity.WARN] = "󰀪 ",
	[vim.diagnostic.severity.INFO] = "󰋽 ",
	[vim.diagnostic.severity.HINT] = "󰌶 ",
}

vim.diagnostic.config({
	signs = {
		text = signs,
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
		},
	},
	-- virtual_lines = true,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = function(diagnostic)
			return signs[diagnostic.severity] or "●"
		end,
	},
	underline = true,
	severity_sort = true,
	update_in_insert = false,
})

-- ***** LSP *****
vim.lsp.config("oxlint", {
	settings = {
		fixKind = "all",
	},
})

-- Symbol kinds to show, filtering out noisy symbols (like local variables)
local symbol_kinds = {
	"Class",
	"Function",
	"Method",
	"Constructor",
	"Interface",
	"Module",
	"Struct",
	"Trait",
	"Enum",
	"Property",
}
-- Snacks has its own Lua-specific list, so override that too
local symbols_filter = { default = symbol_kinds, lua = symbol_kinds }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(event)
		-- a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc, silent = true })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", function()
			Snacks.picker.lsp_definitions()
		end, "[G]oto [D]efinition")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", function()
			Snacks.picker.lsp_declarations()
		end, "[G]oto [D]eclaration")

		-- Find references for the word under your cursor.
		map("gr", function()
			Snacks.picker.lsp_references()
		end, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", function()
			Snacks.picker.lsp_implementations()
		end, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("gy", function()
			Snacks.picker.lsp_type_definitions()
		end, "[G]oto T[y]pe Definition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ss", function()
			Snacks.picker.lsp_symbols({ filter = symbols_filter })
		end, "[S]earch [S]ymbols(open buffer)")

		-- Fuzzy find all the symbols in your current workspace.
		map("<leader>sS", function()
			Snacks.picker.lsp_workspace_symbols({ filter = symbols_filter })
		end, "[S]earch [S]ymbols (workspace)")

		-- Search Diagnostics
		map("<leader>sd", function()
			Snacks.picker.diagnostics()
		end, "[S]earch [D]iagnostics (workspace)")
		map("<leader>sD", function()
			Snacks.picker.diagnostics_buffer()
		end, "[S]earch [D]iagnostics (open buffer)")

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Signature Help
		map("gK", vim.lsp.buf.signature_help, "Signature Help")
		vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, {
			buffer = event.buf,
			desc = "LSP: Signature Help",
			silent = true,
		})
	end,
})
