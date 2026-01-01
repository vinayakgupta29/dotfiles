return {
  "xiyaowong/transparent.nvim",
  lazy = false,    -- IMPORTANT: do not lazy-load
  priority = 1000, -- load before UI plugins
  config = function()
    local transparent = require("transparent")

    transparent.setup({
      extra_groups = {
        "NormalFloat",
        "FloatBorder",
      },
      exclude_groups = {
        "NonText",
        "CursorLine",
        "StatusLine",
        "StatusLineNC",
      },
    })

    -- Clear all NeoTree-related highlights
    transparent.clear_prefix("NeoTree")

    -- Enable transparency on startup
    vim.cmd("TransparentEnable")

    -- Re-apply after any colorscheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.cmd("TransparentEnable")
      end,
    })
  end,
}
