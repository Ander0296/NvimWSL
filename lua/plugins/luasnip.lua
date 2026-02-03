return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (vim.fn.has("win32") == 0)
        and "echo 'NOTE: jsregexp is optional'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
}
