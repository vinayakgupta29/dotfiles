return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "go", "python", "javascript", "typescript", "html", "css", "json", "markdown"
        },
        highlight = {
          enable = true,
        },
        autotag = {
          enable = true,
        }
      })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
  },
}
