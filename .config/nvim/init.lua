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


require("config.lazy")

-- Close the buffer

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
require("custom.remap")
