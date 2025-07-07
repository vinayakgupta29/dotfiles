-- ~/.config/nvim/lua/plugins/neotree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("neo-tree").setup({
      enable_git_status = true, -- ✅ Make sure git integration is enabled
      
      git_status = {
        symbols = {
          added      = "✓",   -- staged
          modified   = "",   -- unstaged
          deleted    = "",
          renamed    = "➜",
          untracked  = "★",
          ignored    = "◌",
          conflicted = "",
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        renderers = {
          directory = {
            { "icon", default = "", highlight = "NeoTreeDirectoryIcon" },
            { "name", highlight = "NeoTreeDirectoryName" },
            { "git_status", highlight = "NeoTreeGitStatus" },
          },
          file = {
            { "icon", default = "", highlight = "NeoTreeFileIcon" },
            { "name", highlight = "NeoTreeFileName" },
            { "git_status", highlight = "NeoTreeGitStatus" },
          },
        },
      },
    })

    -- ✅ Set git + folder highlights
    local highlights = {
      NeoTreeGitStaged     = { fg = "#81b88b" },
      NeoTreeGitUnstaged   = { fg = "#e2c08d" },
      NeoTreeGitUntracked  = { fg = "#73c991" },
      NeoTreeGitIgnored    = { fg = "#8c8c8c" },
      NeoTreeGitRenamed    = { fg = "#73c991" },
      NeoTreeGitDeleted    = { fg = "#f97583" },
      NeoTreeGitConflict   = { fg = "#e4676b" },
      NeoTreeDirectoryName = { fg = "#dadada" },
    }

    for group, hl in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, hl)
    end
  end,
}

