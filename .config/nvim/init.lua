vim.opt.termguicolors = true

vim.opt.number = true

vim.opt.clipboard = "unnamedplus"


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




