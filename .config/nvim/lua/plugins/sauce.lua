return {
  "vinayakgupta29/sauce.nvim",
  config = function()
    require("sauce").setup()

    -- optional: try installing parser (safe)
    pcall(function()
      require("nvim-treesitter.install").install("saucelang")
    end)

    -- apply highlights after colorscheme loads
    local function set_colors()
      -- use your custom groups (recommended)
      vim.api.nvim_set_hl(0, "@sauce.title", { fg = "#89b4fa", bold = true })
      vim.api.nvim_set_hl(0, "@sauce.cast", { fg = "#f38ba8" })
      vim.api.nvim_set_hl(0, "@sauce.category", { fg = "#a6e3a1" })
      vim.api.nvim_set_hl(0, "@sauce.time", { fg = "#fab387" })

      -- punctuation / operators (optional tweak)
      vim.api.nvim_set_hl(0, "@operator", { fg = "#cba6f7" })
      vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#9399b2" })
      vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#bac2de" })
    end

    -- critical: defer so it runs after colorscheme
    vim.schedule(set_colors)

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_colors,
    })
  end
}
