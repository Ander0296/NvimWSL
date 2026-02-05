
return {
  {
    "stevearc/aerial.nvim",
    event = "BufReadPost",

    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,

      layout = {
        resize_to_content = false,
        win_opts = {
          signcolumn = "yes",
        },
      },

      icons = {
        Class = "󰠱 ",
        Function = "󰊕 ",
        Method = "󰆧 ",
        Variable = "󰀫 ",
        Field = "󰜢 ",
        Module = " ",
        Struct = "󰙅 ",
      },
    },

    keys = {
      { "<leader>ao", "<cmd>AerialToggle<cr>", desc = "Outline (Aerial)" },
      { "<leader>af", "<cmd>AerialNavToggle<cr>", desc = "Outline flotante" },
      { "<leader>as", "<cmd>Telescope aerial<cr>", desc = "Símbolos (buscar)" },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    config = function()
      pcall(require("telescope").load_extension, "aerial")
    end,
  },
}
