
return {
  {
    "gbprod/yanky.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- reemplazo de LazyFile
    dependencies = {
      -- Opcional: historial en Telescope
      { "nvim-telescope/telescope.nvim", optional = true },
      { "gbprod/yanky.nvim", optional = true },
      { "nvim-lua/plenary.nvim", optional = true },
      { "gbprod/telescope-yank-history.nvim", optional = true },
    },
    opts = {
      system_clipboard = {
        sync_with_ring = not vim.env.SSH_CONNECTION,
      },
      highlight = { timer = 150 },
    },
    keys = {
      {
        "<leader>p",
        function()
          -- 1) Si hay telescope + extensión yank_history, úsala
          local ok_tel, telescope = pcall(require, "telescope")
          if ok_tel then
            local ok_ext = pcall(telescope.load_extension, "yank_history")
            if ok_ext then
              telescope.extensions.yank_history.yank_history({})
              return
            end
          end
          -- 2) Fallback: UI interna
          vim.cmd("YankyRingHistory")
        end,
        mode = { "n", "x" },
        desc = "Abrir historial de copias",
      },

      -- Yank / Put (mejorados)
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Copiar (yanky)" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Pegar después" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Pegar antes" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Pegar después (mantener selección)" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Pegar antes (mantener selección)" },

      -- Historial
      { "[y", "<Plug>(YankyCycleForward)", desc = "Siguiente del historial" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Anterior del historial" },

      -- Pegar con indent
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Pegar con indent después (línea)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Pegar con indent antes (línea)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Pegar con indent después (línea)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Pegar con indent antes (línea)" },

      -- Shift + paste (indent)
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Pegar e indentar a la derecha" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Pegar e indentar a la izquierda" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Pegar antes e indentar a la derecha" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Pegar antes e indentar a la izquierda" },

      -- Filtros
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Pegar después aplicando filtro" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Pegar antes aplicando filtro" },
    },

    config = function(_, opts)
      require("yanky").setup(opts)

      -- Si telescope-yank-history está instalado, intenta cargarlo (sin romper si no está)
      local ok_tel, telescope = pcall(require, "telescope")
      if ok_tel then
        pcall(telescope.load_extension, "yank_history")
      end
    end,
  },
}
