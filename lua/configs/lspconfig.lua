require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "golangci_lint_ls" }
vim.lsp.enable(servers)

-- On a fresh machine a buffer can be opened before Mason has installed its
-- server. Re-enable the configs after Mason finishes so those buffers attach.
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  callback = function()
    vim.schedule(function()
      pcall(vim.lsp.enable, servers)
    end)
  end,
})

-- read :h vim.lsp.config for changing options of lsp servers
