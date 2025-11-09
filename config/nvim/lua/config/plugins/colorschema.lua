return {
  -- NOTE: dracula
  { "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup({
        transparent_bg = true,
        italic_comment = true
      })

      -- HACK: set this on the color you want to be persistent
      -- when quit and reopening nvim
      -- vim.cmd("colorscheme dracula-soft")
      -- OR
      -- vim.cmd("colorscheme dracula")
    end
  },
  -- NOTE: catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, auto
        transparent_background = true,
        lsp_styles = {
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        float = {
          transparent = true,
          solid = false
        },

        integrations = {
          which_key = true,
          fzf = true,
        },
      })

      -- HACK: set this on the color you want to be persistent
      -- when quit and reopening nvim
      vim.opt.winborder = "rounded"
      vim.cmd("colorscheme catppuccin")
    end
  }

}
