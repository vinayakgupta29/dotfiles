vim.opt.termguicolors = true

vim.opt.number = true

vim.opt.clipboard = "unnamedplus"



require("config.lazy")

vim.keymap.set("n", "<A-e>", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true })

local floating_shell = require("config.floating_shell")
vim.keymap.set("n", "<A-t>", floating_shell.toggle_floating_shell, { noremap = true, silent = true })

local trash = require('config.trash')
vim.keymap.set("n", "<leader>dt", trash.trash_file, {noremap = true, silent = true})

vim.keymap.set("n", "<A-f>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", "<cmd>Telescope git_branches<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Project-wide grep" })



