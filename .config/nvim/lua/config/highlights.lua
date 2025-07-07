-- ~/.config/nvim/lua/config/highlights.lua
local function set_nvim_tree_git_colors()
  vim.api.nvim_set_hl(0, "NvimTreeGitStaged",    { fg = "#81b88b" })
  vim.api.nvim_set_hl(0, "NvimTreeGitUnstaged",  { fg = "#e2c08d" })
  vim.api.nvim_set_hl(0, "NvimTreeGitUnmerged",  { fg = "#e4676b" })
  vim.api.nvim_set_hl(0, "NvimTreeGitRenamed",   { fg = "#73c991" })
  vim.api.nvim_set_hl(0, "NvimTreeGitNew",       { fg = "#73b8ff" })
  vim.api.nvim_set_hl(0, "NvimTreeGitDeleted",   { fg = "#f97583" })
  vim.api.nvim_set_hl(0, "NvimTreeGitIgnored",   { fg = "#8c8c8c" })

  vim.api.nvim_set_hl(0, "NvimTreeNormal",               { fg = "#dadada", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeFolderName",           { fg = "#dadada", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName",     { fg = "#dadada", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeRootFolder",           { fg = "#dadada", bg = "NONE" })
end

set_nvim_tree_git_colors()

