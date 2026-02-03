return {
  "numToStr/Comment.nvim",                  -- Plugin principal para comentar/descomentar código
  event = { "BufReadPre", "BufNewFile" },   -- Se carga al abrir o crear archivos
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", -- Soporte para comentarios contextuales (por ejemplo, en JSX, TSX, HTML, Svelte)
  },
  config = function()
    -- Importa el plugin principal de comentarios
    local comment = require("Comment")

    -- Importa la integración para comentarios contextuales
    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- Configura el plugin de comentarios
    comment.setup({
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
