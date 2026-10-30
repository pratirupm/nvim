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
-- wrap and linebreak are window-local, so apply them per window and clear
-- them when a code buffer replaces prose in the same window.
local prose_filetypes = {
  markdown = true,
  text = true,
  gitcommit = true,
  asciidoc = true,
}

-- These filetypes manage wrapping themselves.
local self_wrapping_filetypes = {
  help = true,
  man = true,
}

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("UserWrapText", { clear = true }),
  desc = "Soft-wrap prose filetypes",
  callback = function()
    local filetype = vim.bo.filetype
    if self_wrapping_filetypes[filetype] then
      return
    end

    local prose = prose_filetypes[filetype] == true
    vim.wo.wrap = prose
    vim.wo.linebreak = prose
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserYankHighlight", { clear = true }),
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})
