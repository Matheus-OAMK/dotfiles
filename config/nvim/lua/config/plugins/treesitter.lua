return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
  opts = {
    ensure_installed = {
      "vim",
      "vimdoc",
      "lua",
      "luadoc",
      "bash",
      "diff",
      "html",
      "css",
      "markdown",
      "markdown_inline",
      "rust",
      "python",
      "c",
      "javascript",
      "typescript",
      "tsx",
      "toml",
      "yaml",
      "json",
      "jsonc",
      "sql",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    folds = { enable = true },
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter")

    TS.setup(opts)

    TS.install(opts.ensure_installed)
    vim.treesitter.language.register("bash", "zsh")


    -- auto-start highlights & indentation
    vim.api.nvim_create_autocmd("FileType", {
      desc = "User: enable treesitter highlighting",
      callback = function(ctx)
        local bufnr = ctx.buf
        if not pcall(vim.treesitter.start, bufnr) then return end

        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

      end,
    })

  end,
}
