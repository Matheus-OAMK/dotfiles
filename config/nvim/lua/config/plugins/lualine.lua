return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        -- theme = "palenight",
        -- theme = "moonfly",
        disabled_filetypes = { statusline = { "snacks_dashboard", "snacks_picker_list" } },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {"diff"},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    },
  }

}
