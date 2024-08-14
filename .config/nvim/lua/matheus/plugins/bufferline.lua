return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      mode = "tabs",
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true -- use a "true" to enable the default, or set your own character
        },
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true -- use a "true" to enable the default, or set your own character
        },
      },
    },
  },
}
