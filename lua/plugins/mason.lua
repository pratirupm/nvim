return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    cmd = {
      "MasonToolsClean",
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
    },
    opts = {
      ensure_installed = {
        -- Existing NvChad language servers, so a fresh clone works.
        "lua-language-server",
        "html-lsp",
        "css-lsp",

        -- Go language servers and tools.
        "gopls",
        "delve",
        "goimports",
        "golines",
        "golangci-lint",
        "golangci-lint-langserver",
        "gotestsum",
        "gomodifytags",
        "gotests",
        "impl",
        "iferr",

        -- Formatters and Tree-sitter parser builds.
        "stylua",
        "tree-sitter-cli",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)

      -- If a Go buffer was opened while Mason was installing gopls, restart the
      -- clients so the newly installed server is picked up.
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function(args)
          if args.data and #args.data > 0 then
            pcall(vim.cmd, "LspRestart")
          end
        end,
      })
    end,
  },
}
