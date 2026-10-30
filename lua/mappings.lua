require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Helix-style word selection for the visual surround aliases in workflow.lua.
map("n", "miw", "viw", { desc = "Select inside word" })
map("n", "maw", "vaw", { desc = "Select around word" })
map("n", "miW", "viW", { desc = "Select inside WORD" })
map("n", "maW", "vaW", { desc = "Select around WORD" })
