vim.opt.termguicolors = true

vim.opt.number = true

vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.o.mouse = "a"

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


vim.keymap.set("n", "<A-t>", function()
  vim.o.splitright = true
  local buf_path = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(buf_path, ":p:h") -- get directory of current file
  if dir == "" then
    dir = vim.fn.getcwd() -- fallback to CWD if buffer has no file
  end
  vim.cmd("vsplit")                            -- open vertical split
  vim.cmd("terminal fish")                     -- open fish shell in terminal
  vim.cmd("lcd " .. dir)                       -- set local dir for that window
end, { noremap = true, silent = true, desc = "Open Fish shell in current dir" })



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

vim.keymap.set("n", "<Q>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].modified then
    local choice = vim.fn.input("Buffer has unsaved changes. Save? (y/n/c): ")

    if choice == "y" then
      vim.cmd("write")        -- Save and continue to close
    elseif choice == "n" then
      vim.bo[bufnr].modified = false -- Mark as not modified to force close
    else
      print("Canceled")
      return
    end
  end

  -- Close the buffer
  vim.cmd("bdelete")
end, { noremap = true, silent = true, desc = "Close buffer with prompt if unsaved" })

