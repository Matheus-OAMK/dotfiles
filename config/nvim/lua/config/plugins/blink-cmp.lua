return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      "onsails/lspkind.nvim", -- vs code like pictogram
      "nvim-mini/mini.icons", -- Optional, for file icons
    },

    opts = {
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250  },
        ghost_text= { enabled = true },
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, _ = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                    if mini_icon then return mini_icon .. ctx.icon_gap end
                  end

                  local icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from mini.icons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, mini_hl = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                    if mini_icon then return mini_hl end
                  end
                  return ctx.kind_hl
                end,
              },
              kind = {
                -- Optional, use highlights from mini.icons
                highlight = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, mini_hl = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                    if mini_icon then return mini_hl end
                  end
                  return ctx.kind_hl
                end,
              }
            }
          }
        }
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "rust" }
    },
    opts_extend = { "sources.default" }
  }
}
