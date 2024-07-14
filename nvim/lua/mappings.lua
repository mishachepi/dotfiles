require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
-- help: map("insert mode", "jk keys", "Action")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
