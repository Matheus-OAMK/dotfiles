return {
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "BufWinEnter",
    init = function()
      vim.g.copilot_no_maps = true
    end,
    config = function()
      -- Block the normal Copilot suggestions
      vim.api.nvim_create_augroup("github_copilot", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
        group = "github_copilot",
        callback = function(args)
          vim.fn["copilot#On" .. args.event]()
        end,
      })
      vim.fn["copilot#OnFileType"]()
    end,
  },

  {
    'saghen/blink.cmp',
    version = '1.*',
    event = { "InsertEnter", "CmdlineEnter" },
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      "onsails/lspkind.nvim", -- vs code like pictogram
      "nvim-mini/mini.icons", -- Optional, for file icoons
      "fang2hou/blink-copilot",
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
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end

                  elseif ctx.kind == "Copilot" then
                    icon = ctx.kind_icon -- keep the default icon for Copilot

                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              }
            },
            treesitter = { "lsp" },
          }
        }
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      fuzzy = { implementation = "rust" }
    },
    opts_extend = { "sources.default" }
  }
}
