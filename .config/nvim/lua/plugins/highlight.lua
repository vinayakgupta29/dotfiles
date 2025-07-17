return {
  "navarasu/onedark.nvim",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'warmer'
    }
    -- Enable theme
    require('onedark').load()
  end
}

-- return {
--  "ramojus/mellifluous.nvim",
--  -- version = "v0.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
--  config = function()
--    require("mellifluous").setup({}) -- optional, see configuration section.
--    vim.cmd("colorscheme mellifluous")
--  end,
-- }
-- return {
--    'AlexvZyl/nordic.nvim',
--    lazy = false,
--    priority = 1000,
--    config = function()
--        require('nordic').load()
--    end
-- }
