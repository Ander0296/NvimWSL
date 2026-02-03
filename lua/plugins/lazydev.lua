
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- solo carga cuando editas lua (cero costo startup)
    cmd = "LazyDev",
    opts = {
      library = {
        -- Tipos de Neovim core (vim.uv, async, fs, etc)
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },

        -- Si usas lazy.nvim (plugin manager)
        { path = "lazy.nvim", words = { "Lazy" } },

        -- Si usas snacks
        { path = "snacks.nvim", words = { "Snacks" } },

        -- 👇 opcional: tus snippets Lua locales
        { path = vim.fn.stdpath("config") .. "/lua", words = { "require" } },
      },
    },
  },
}
