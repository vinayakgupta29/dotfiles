-- lua/plugins/bufferline.lua
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      highlights = {
        buffer_selected = {
          fg = "#FFFFFF",
          bold = true,
        },
      },
      options = {
        separator_style = "slant",
        themable = true,
        color_icons = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {}
        }


      }
    })
  end
}
