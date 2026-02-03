-- lua/plugins/colorscheme-gruvbox.lua
return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- carga antes que otros plugins UI
    lazy = false,    -- aplica al iniciar
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invierte highlights de búsqueda, diff, etc
      contrast = "hard", -- "soft" | "medium" | "hard"
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark" -- "dark" | "light"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
