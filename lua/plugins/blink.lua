
return {
  -- Snippets (colección)
  { "rafamadriz/friendly-snippets" },

  -- Compat layer (solo si lo necesitas para fuentes estilo nvim-cmp)
  {
    "saghen/blink.compat",
    optional = true,
    version = "*",
    opts = {},
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },

    opts = {
      snippets = {
        preset = "luasnip", -- usa vim.snippet
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },

      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = false, -- pon true si quieres “texto fantasma”
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },

    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },
}
