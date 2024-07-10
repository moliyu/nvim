return {
  {
    "Mofiqul/dracula.nvim",
    opts = {
      transparent_bg = true,
      colors = {
        visual = "#409eff",
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "mrshmllow/document-color.nvim",
    opts = {
      mode = "background",
    },
  },
}
