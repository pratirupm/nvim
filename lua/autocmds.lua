require "nvchad.autocmds"

-- Filetype plugins can set their own indentation; enforce the four-column
-- preference after those plugins have run.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserIndent", { clear = true }),
  desc = "Use four-column indentation in every filetype",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Code stays unwrapped, but prose is easier to read with soft wrapping.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserWrapText", { clear = true }),
  pattern = { "markdown", "text", "gitcommit", "asciidoc" },
  desc = "Soft-wrap prose filetypes",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserYankHighlight", { clear = true }),
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})
