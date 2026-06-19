-- For lazy.nvim
return
{
  "MeanderingProgrammer/render-markdown.nvim",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  opts = {
    render_modes = true,
  },
}
