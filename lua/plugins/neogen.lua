
return {
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = {
      "L3MON4D3/LuaSnip", -- si usas luasnip
      -- o "nvim-mini/mini.snippets" si algún día usaras mini
    },
    opts = {
      snippet_engine = "luasnip", -- 👈 importante para ti
    },
    keys = {
      {
        "<leader>cn",
        function()
          require("neogen").generate()
        end,
        desc = "Generar documentación",
      },
    },
  },
}
