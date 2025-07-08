vim.opt.termguicolors = true

vim.opt.number = true

vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', 'dd', '"_dd', opts)
vim.api.nvim_set_keymap('n', 'dw', '"_dw', opts)
vim.api.nvim_set_keymap('n', 'x',  '"_x',  opts)

-- If nvim is launched with a directory as the first argument,
-- set that directory as the working directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg and vim.fn.isdirectory(arg) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(arg))
    end
  end,
})

vim.api.nvim_set_hl(0, "NeoTreeExecutable", { fg = "#32CD32" })  -- lime green


require("config.lazy")

vim.keymap.set("n", "<A-e>", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true })

local floating_shell = require("config.floating_shell")
vim.keymap.set("n", "<A-t>", floating_shell.toggle_floating_shell, { noremap = true, silent = true })

local trash = require('config.trash')
vim.keymap.set("n", "<leader>dt", trash.trash_file, {noremap = true, silent = true})

local telescope = require("telescope.builtin")

local telescope = require("telescope.builtin")

vim.keymap.set("n", "<A-f>", function()
  telescope.find_files({
    cwd = vim.loop.cwd(), -- will now be the opened folder
    hidden = true,        -- include dotfiles
    follow = true,        -- follow symlinks
    no_ignore = true,     -- ignore .gitignore and .ignore
  })
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>b", function()
  telescope.git_branches({ cwd = vim.loop.cwd() })
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>fg", function()
  telescope.live_grep({
    cwd = vim.loop.cwd(),
    additional_args = { "--hidden" }, -- also search hidden files
  })
end, { noremap = true, silent = true })

local bufferline = require("bufferline")

vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<C-w>", ":bd<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<C-LeftMouse>",
  "<cmd>Telescope lsp_definitions<CR>",
  { noremap = true, silent = true }
)




