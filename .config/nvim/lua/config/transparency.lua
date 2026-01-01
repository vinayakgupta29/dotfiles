vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(function()
      local groups = {
        -- Core
        "Normal",
        "NormalNC",
        "EndOfBuffer",
        "SignColumn",
        "VertSplit",
        "StatusLine",
        "StatusLineNC",

        -- Floats / menus
        "NormalFloat",
        "FloatBorder",
        "Pmenu",
        "PmenuSel",

        -- Neo-tree
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeEndOfBuffer",
        "NeoTreeVertSplit",
      }

      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end)
  end,
})
