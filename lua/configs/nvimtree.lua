local opts = require "nvchad.configs.nvimtree"

opts.view.side = "right"
opts.actions = vim.tbl_deep_extend("force", opts.actions or {}, {
  open_file = { quit_on_open = true },
})

return opts
