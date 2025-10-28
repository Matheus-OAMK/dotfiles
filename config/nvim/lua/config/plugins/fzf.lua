return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    winopts = {
      height = 0.80,
      width = 0.80,
      preview = {
        layout = "flex", -- can be "vertical", "horizontal", "flex"
      },
    },
    files = {

      cwd_prompt = false,
      hidden = true, -- show hidden files
      fd_opts = [[--color=never --type f --type l --hidden --follow --exclude .git]],
      formatter = "path.filename_first",
      -- actions = {
      --   ["alt-i"] =  actions.toggle_ignore ,
      --   ["alt-h"] =  actions.toggle_hidden ,
      -- },
    },
    buffers = {
      formatter = "path.filename_first",  -- ← Telescope-style truncation
      path_shorten=true
    },

    grep = {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
    },
    keymap = {
      builtin = {
        ["<C-j>"] = "down", -- move down in results
        ["<C-k>"] = "up", -- move up in results
        -- ["<C-q>"] = "toggle-all+accept", -- send all to quickfix
      },
    },
  },
  keys = function()
    local fzf = require("fzf-lua")

    local function map(lhs, fn, desc)
      return { lhs, fn, mode = "n", desc = desc }
    end

    return {
      map("<leader>sh", fzf.help_tags,         "[S]earch [H]elp"),
      map("<leader>sk", fzf.keymaps,           "[S]earch [K]eymaps"),
      map("<leader>sf", fzf.files,             "[S]earch [F]iles"),
      map("<leader>ss", fzf.builtin,           "[S]earch [S]elect Picker"),
      map("<leader>sw", fzf.grep_cword,        "[S]earch current [W]ord"),
      -- map("<leader>sg", fzf.live_grep,         "[S]earch by [G]rep"),
      map("<leader>sd", fzf.diagnostics_document, "[S]earch [D]iagnostics"),
      map("<leader>sr", fzf.resume,            "[S]earch [R]esume"),
      map("<leader>s.", fzf.oldfiles,          '[S]earch Recent Files ("." for repeat)'),
      map("<leader><leader>", fzf.buffers,     "[ ] Find existing buffers"),

      -- your new ones
      map("<leader>/", function()
        fzf.blines({previewer = false})
      end, "[/] Fuzzily search in current buffer"),

      map("<leader>s/", function()
        fzf.live_grep({
          cwd = MyUtils.root.get(),
          rg_opts = "--no-heading --with-filename --line-number --column --smart-case --color=always",
        })
      end, "[S]earch [/] in Open Files"),


      map("<leader>sg", function()
        fzf.live_grep({
          cwd = MyUtils.root.get(),
        })
      end, "[S]earch by [G]rep (root)"),


      map("<leader>sG", function()
        fzf.live_grep({
          cwd = MyUtils.root.get(),
        })
      end, "[S]earch by [G]rep (cwd)"),

      map("<leader>sn", function()
        fzf.files({ cwd = vim.fn.stdpath("config") })
      end, "[S]earch [N]eovim config"),
    }
  end,
}
