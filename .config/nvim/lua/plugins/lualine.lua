local dark_theme = {
  normal = {
    a = { fg = "#ffffff", bg = "#005f87", gui = "bold" }, -- blue
    b = { fg = "#a9c181", bg = "#1b2931" },
    c = { fg = "#c0c0c0", bg = "#1a1a1a" },
  },
  insert = {
    a = { fg = "#ffffff", bg = "#32CD32", gui = "bold" }, -- lime green
  },
  visual = {
    a = { fg = "#ffffff", bg = "#5f00af", gui = "bold" },
  },
  replace = {
    a = { fg = "#ffffff", bg = "#af0000", gui = "bold" },
  },
  inactive = {
    a = { fg = "#888888", bg = "#1e1e1e" },
    b = { fg = "#888888", bg = "#1e1e1e" },
    c = { fg = "#888888", bg = "#1e1e1e" },
  },
}


return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- for file icons
    config = function()
      require('lualine').setup {
        options = {
          theme = dark_theme,  -- <-- set the theme here
          section_separators = {'', ''},
          component_separators = {'', ''},
          icons_enabled = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      }
    end,
  },
}

