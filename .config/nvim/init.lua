vim.opt.termguicolors = true

vim.opt.number = true

vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.api.nvim_set_hl(0, "StatusLine", {})

vim.o.mouse = "a"

if vim.g.neovide then
  vim.o.guifont = "FiraCode Nerd Font:h10"
end
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

vim.api.nvim_set_hl(0, "NeoTreeExecutable", { fg = "#32CD32" }) -- lime green
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- If Neo-tree is focused
    if vim.bo.filetype == "neo-tree" then
      -- Count listed (real) buffers
      local listed_buffers = vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
      local win_count = #vim.api.nvim_list_wins()

      -- If Neo-tree is the only window AND there are no other buffers, quit nvim
      if listed_buffers == 1 and win_count == 1 then
        vim.cmd("quit")
      end
    end
  end,
})


require("config.lazy")


vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
require("custom.remap")
