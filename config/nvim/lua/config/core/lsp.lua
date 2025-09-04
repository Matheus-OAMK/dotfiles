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


-- ***** LSP *****
-- LUA
vim.lsp.config("lua_ls", {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJit",
      },
    },
  },
})
vim.lsp.enable({
  "lua_ls"
})

-- RUFF
vim.lsp.config("ruff", {
  cmd = { 'ruff', "server" },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'ruff.toml',
    '.ruff.toml',
    '.git'
  },
  settings = {},
})
vim.lsp.enable({
  "ruff"
})


vim.lsp.config("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  }
})
vim.lsp.enable({
  "basedpyright"
})
