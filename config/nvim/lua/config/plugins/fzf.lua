return {
  "ibhagwan/fzf-lua",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  dependencies = {
    "nvim-mini/mini.icons",
    "folke/snacks.nvim"
  },
  opts = function()
    local fzf = require("fzf-lua")
    local config = fzf.config
    local actions = fzf.actions

    -- Quickfix
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"

    -- Register fzf-lua to be the handler for vim.ui.select
    -- Optionally pass a custom ui_select override from opts
    fzf.register_ui_select({
      winopts = {
        height = 0.6,
        width = 0.7,
        preview = {
          layout = "vertical", -- can be "vertical", "horizontal", "flex"
        },
      },
    })

    return {
      "default-title",
      winopts = {
        height = 0.9,
        width = 0.9,
        preview = {
          layout = "flex", -- can be "vertical", "horizontal", "flex"
        },
      },
      files = {
        file_icons = "mini",
        cwd_prompt = true,
        cwd_prompt_shorten_len = 40,        -- shorten prompt beyond this length
        -- cwd_header = true,
        fd_opts = [[--color=never --type f --type l --exclude .git --exclude node_modules]],
        hidden = true, -- show hidden files
        follow = true,
        no_ignore = false, -- respect .gitignore
        formatter = "path.filename_first",
        actions = {
          ["alt-i"] =  actions.toggle_ignore,
          ["alt-h"] =  actions.toggle_hidden,
        },
      },
      buffers = {
        formatter = "path.filename_first",  -- ← Telescope-style truncation
        path_shorten=true
      },

      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
        hidden = true, -- show hidden by default
        follow = true, -- follow symlinks by default
        no_ignore = false, -- respect ".gitignore"  by default
        actions = {
          ["alt-i"] =  actions.toggle_ignore,
          ["alt-h"] =  actions.toggle_hidden,
        },
      },
    }
  end,
  keys = function()
    local fzf = require("fzf-lua")

    local function map(lhs, fn, desc)
      return { lhs, fn, mode = "n", desc = desc }
    end

    return {
      -- ***** Find *****
      map("<leader><leader>", fzf.buffers, "[ ] Find existing buffers"),
      map("<leader>fr", fzf.oldfiles, "[F]ind [R]ecent Files"),

      map("<leader>fR", function()
        fzf.oldsfiles({ cwd = vim.uv.cwd() })
      end, "[F]ind [R]ecent Files (cwd)"),

      map("<leader>fF", fzf.files, "[S]earch [F]iles (cwd)"),

      map("<leader>ff", function()
        fzf.files({ cwd = MyUtils.root.get() })
      end, "[F]ind [F]iles (root)"),

      map("<leader>fn", function()
        fzf.files({ cwd = vim.fn.stdpath("config") })
      end, "[F]ind [N]eovim Config"),

      -- ***** Search *****
      map("<leader>sh", fzf.help_tags, "[S]earch [H]elp Pages"),
      map("<leader>sk", fzf.keymaps, "[S]earch [K]eymaps"),
      map("<leader>sr", fzf.resume, "[S]earch [R]esume"),
      map("<leader>sp", fzf.builtin, "[S]earch Select [P]icker"),
      map("<leader>sq", fzf.quickfix, "[S]earch [Q]uick Fix"),

      map("<leader>sg", function()
        fzf.live_grep({ cwd = MyUtils.root.get() })
      end, "[S]earch by [G]rep (root)"),

      map("<leader>sG", function()
        fzf.live_grep()
      end, "[S]earch by [G]rep (cwd)"),

      map("<leader>sW", fzf.grep_cword, "[S]earch Current [W]ord (cwd)"),

      map("<leader>sw", function()
        fzf.live_grep({ cwd = MyUtils.root.get() })
      end, "[S]earch Current [W]ord (root)"),

      map("<leader>/", function()
        fzf.blines({ previewer = false })
      end, "[/] Search in current buffer"),

      map("<leader>s/", function()
        fzf.lines()
      end, "[S]earch [/] in Open Buffers"),
    }
  end,
}
