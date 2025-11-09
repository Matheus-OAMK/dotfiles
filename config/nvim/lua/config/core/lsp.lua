-- ***** DIAGNOSTICS *****
-- Define sign icons for each severity
local signs = {
  [vim.diagnostic.severity.ERROR] = "󰅚 ",
  [vim.diagnostic.severity.WARN] = "󰀪 ",
  [vim.diagnostic.severity.INFO] = "󰋽 ",
  [vim.diagnostic.severity.HINT] = "󰌶 ",
}

vim.diagnostic.config({
  signs = { text = signs,
  numhl = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
    [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
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


-- -- ***** LSP *****
-- -- LUA
-- vim.lsp.enable("lua_ls")
--
-- -- RUFF
-- vim.lsp.enable("ruff")
--
-- -- BASEDPYRIGHT
-- vim.lsp.enable("basedpyright")
--


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
    map("gd", "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>", "[G]oto [D]efinition")

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map("gD", "<cmd>FzfLua lsp_declarations jump1=true ignore_current_line=true<cr>", "[G]oto [D]eclaration")

    -- Find references for the word under your cursor.
    map("gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>" , "[G]oto [R]eferences")

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map("gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", "[G]oto [I]mplementation")

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map("<leader>gt", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>", "[G]oto [T]ype Definition")

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map("<leader>ss", function()
      require("fzf-lua").lsp_document_symbols({
        regex_filter = symbols_fiter
      }) end,
      "[S]earch [S]ymbols(open buffer)"
    )

    -- Fuzzy find all the symbols in your current workspace.
    map("<leader>sS", function()
      require("fzf-lua").lsp_live_workspace_symbols({
        regex_filter = symbols_filter,
      })
      end,
      "[S]earch [S]ymbols (workspace)"
    )

    map("<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", "[S]earch [D]iagnostics (open buffer)")

    map("<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", "[S]earch [D]iagnostics (workspace)")


    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")


    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})
