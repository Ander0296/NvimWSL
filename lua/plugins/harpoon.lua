-- List of favorite files/marks per project
return {
  {
    -- https://github.com/ThePrimeagen/harpoon
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    opts = {
      menu = {
        width = 120,
      },
    },

    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,

    -- =========================
    -- KEYMAPS (integrados Lazy)
    -- =========================
    keys = function()
      local harpoon = require("harpoon")
      local list = harpoon:list()

      local keys = {
        -- marcar archivo actual
        {
          "<leader>ha",
          function()
            list:append()
          end,
          desc = "Harpoon: Marcar archivo actual",
        },

        -- menú rápido
        {
          "<leader>hh",
          function()
            harpoon.ui:toggle_quick_menu(list)
          end,
          desc = "Harpoon: Mostrar menú",
        },

        -- navegación rápida
        {
          "<leader>hn",
          function()
            list:next()
          end,
          desc = "Harpoon: Siguiente",
        },
        {
          "<leader>hp",
          function()
            list:prev()
          end,
          desc = "Harpoon: Anterior",
        },
      }

      -- slots 1–9 automáticos
      for i = 1, 9 do
        table.insert(keys, {
          "<leader>h" .. i,
          function()
            list:select(i)
          end,
          desc = "Harpoon: Ir al archivo " .. i,
        })
      end

      return keys
    end,
  },
}
