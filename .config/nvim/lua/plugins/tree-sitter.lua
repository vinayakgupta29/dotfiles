return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    dependencies = {
      "windwp/nvim-ts-autotag",
    },

    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "lua",
          "go",
          "python",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "markdown",
          "markdown_inline",
        },

        highlight = {
          enable = true,
        },

        autotag = {
          enable = true,
        },
      })
    end,
  },
}
