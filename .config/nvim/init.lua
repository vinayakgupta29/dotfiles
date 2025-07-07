vim.opt.termguicolors = true

vim.opt.number = true

vim.opt.clipboard = "unnamedplus"



require("config.lazy")

vim.keymap.set("n", "<A-e>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

local floating_shell = require("config.floating_shell")
vim.keymap.set("n", "<A-t>", floating_shell.toggle_floating_shell, { noremap = true, silent = true })

local trash = require('config.trash')
vim.keymap.set("n", "<leader>dt", trash.trash_file, {noremap = true, silent = true})

 vim.cmd("colorscheme habamax")

-- Now set your custom highlights
vim.cmd [[ highlight NvimTreeNormal guifg=#ffffff guibg=NONE ]]
vim.cmd [[ highlight NvimTreeFolderName guifg=#ffffff guibg=NONE ]]
vim.cmd [[ highlight NvimTreeOpenedFolderName guifg=#ffffff guibg=NONE ]]
vim.cmd [[ highlight NvimTreeRootFolder guifg=#ffffff guibg=NONE ]]

vim.cmd [[ hi! NvimTreeGitNew guifg=#4EC9B0 guibg=NONE ]]
vim.cmd [[ hi! NvimTreeGitDirty guifg=#D7BA7D guibg=NONE ]]
vim.cmd [[ hi! NvimTreeGitDeleted guifg=#F44747 guibg=NONE ]]
vim.cmd [[ highlight NvimTreeGitStaged guifg=#569CD6 guibg=NONE ]]
vim.cmd [[ highlight NvimTreeGitIgnored guifg=#8C8C8C guibg=NONE ]]
vim.cmd [[ highlight NvimTreeGitRenamed guifg=#CE9178 guibg=NONE ]]
vim.cmd [[ highlight NvimTreeGitMerge guifg=#B4009E guibg=NONE ]]
