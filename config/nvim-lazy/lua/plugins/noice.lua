return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    cmdline = {
      view = "cmdline",
      format = {
        search_down = { view = "cmdline" },
        search_up = { view = "cmdline" }
      },
    },
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = false,
      inc_rename = false,
    },
  },
}
