-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- use jk for Escape
vim.keymap.set("i", "jk", "<ESC>", { silent = true })

-- Cutlass mappings
vim.keymap.set({ "n", "x" }, "m", "d", { noremap = true, desc = "Cut" })
vim.keymap.set("n", "M", "D", { noremap = true, desc = "Cut to end of line" })
vim.keymap.set("n", "mm", "dd", { noremap = true, desc = "Cut line" })
