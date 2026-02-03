return {
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },

    opts = {
      auto_close = false,
      auto_preview = true,
      use_diagnostic_signs = true,

      modes = {
        lsp = {
          win = { position = "right" }, -- panel a la derecha
        },
      },
    },

    keys = {
      -- =========================
      -- Diagnósticos
      -- =========================
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnósticos (proyecto)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Diagnósticos (archivo)",
      },

      -- =========================
      -- Símbolos / LSP
      -- =========================
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle<cr>",
        desc = "Símbolos del archivo",
      },
      {
        "<leader>cS",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "Referencias / definiciones / LSP",
      },

      -- =========================
      -- Quickfix / Location
      -- =========================
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List",
      },

      -- =========================
      -- Navegación estilo Vim
      -- =========================
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            pcall(vim.cmd.cprev)
          end
        end,
        desc = "Item anterior (Trouble/Quickfix)",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            pcall(vim.cmd.cnext)
          end
        end,
        desc = "Item siguiente (Trouble/Quickfix)",
      },
    },
  },
}
