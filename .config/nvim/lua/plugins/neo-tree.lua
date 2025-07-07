-- ~/.config/nvim/lua/plugins/neotree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
   git_status = {
      symbols = {
    added      = "",
    modified   = "",
    deleted    = "",
    renamed    = "",
    untracked  = "",
    ignored    = "",
    conflicted = "",
  },
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- ✅ Git highlights
    local highlights = {
      NeoTreeGitStaged    = "#81b88b",
      NeoTreeGitUnstaged  = "#e2c08d",
      NeoTreeGitUntracked = "#73c991",
      NeoTreeGitIgnored   = "#8c8c8c",
      NeoTreeGitRenamed   = "#73c991",
      NeoTreeGitDeleted   = "#f97583",
      NeoTreeGitConflict  = "#e4676b",
    }

    for group, color in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, { fg = color })
    end
  end,
}

