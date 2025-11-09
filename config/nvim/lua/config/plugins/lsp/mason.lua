return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- import mason
      local mason = require("mason")

      -- import mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")

      -- import mason-tool-installer
      local mason_tool_installer = require("mason-tool-installer")

      -- Setup mason
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })


      -- If mason-lspconfig is installed, mason-tool-installer can accept lspconfig package names unless the integration is disabled.
      mason_tool_installer.setup({
        ensure_installed = {
          "lua_ls", -- Lua language server
          "stylua", -- lua formatter
          "ts_ls", -- Typescript ( may replace with vtsls )
          "html", -- # HTML language server
          "cssls", -- CSS language server
          "tailwindcss", -- Tailwind CSS language server
          "emmet-language-server", -- HTML/CSS/JS Emmet support eg: div>ul>li*5
          "yamlls", -- YAML
          "jsonls", -- JSON
          "sqlls",
          -- "rust_analyzer",
          -- "pyright",
          "basedpyright",
          -- "prettier", -- prettier formatter
          "ruff",
          -- "eslint_d", -- javascript/typescript linter
          -- "solhint", -- solidity linter
        },
      })

      -- Load this last to setup lsp after installation
      mason_lspconfig.setup({
        -- automatic_enable = false,
      })

    end,
  },
}
