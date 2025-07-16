vim.g.mapleader = " ";


local opts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'v' }, 'dd', '"_dd', opts)
vim.keymap.set({ 'n', 'v' }, 'dw', '"_dw', opts)
vim.keymap.set({ 'n', 'v' }, 'x', '"_x', opts)

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Make <C-c> escape from insert, visual, and terminal modes
vim.keymap.set({ "i", "v", "t" }, "<C-c>", "<Esc>")
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- Paste from system clipboard in visual mode
vim.keymap.set("v", "<leader>p", [["+p]])

-- Cut (delete) to system clipboard in visual mode
vim.keymap.set("v", "<leader>x", [["+d]])
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ bufnr = 0 })
end)



vim.keymap.set("n", "<A-e>", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true })

local shell = require("config.split_shell");
vim.keymap.set("n", "<A-t>", shell.toggle_floating_shell,
  { noremap = true, silent = true, desc = "Open Fish shell in current dir" })



local trash = require('config.trash')
vim.keymap.set("n", "<leader>dt", trash.trash_file, { noremap = true, silent = true })


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
vim.keymap.set('n', '<C-w>', ':bdelete<CR>', { noremap = true, silent = true })


vim.keymap.set("n", "<Q>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].modified then
    local choice = vim.fn.input("Buffer has unsaved changes. Save? (y/n/c): ")

    if choice == "y" then
      vim.cmd("write")               -- Save and continue to close
    elseif choice == "n" then
      vim.bo[bufnr].modified = false -- Mark as not modified to force close
    else
      print("Canceled")
      return
    end
  end
end
)

vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>/", function()
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true })

-- Block-wise comment in visual mode (e.g. /* comment */)
vim.keymap.set("v", "<leader>?", function()
  require("Comment.api").toggle.blockwise(vim.fn.visualmode())
end, { noremap = true, silent = true })
