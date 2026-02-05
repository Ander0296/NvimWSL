
return {
  {
    "nvim-mini/mini.tabline",
    event = "VeryLazy",
    dependencies = {
      "nvim-mini/mini.icons",
    },
    opts = {
      show_icons = true,
      set_vim_settings = true,

      -- tabs reales (tabpages) a la derecha
      tabpage_section = "right",

      -- 🔥 magia visual
      format = function(buf_id, label)
        local MiniIcons = require("mini.icons")

        -- icono por filetype
        local ft = vim.bo[buf_id].filetype
        local icon, hl = MiniIcons.get("filetype", ft)

        -- nombre limpio
        local name = vim.fn.fnamemodify(label, ":t")

        -- número de buffer
        local number = tostring(vim.fn.bufnr(buf_id))

        -- modificado
        local modified = vim.bo[buf_id].modified and " ●" or ""

        -- armado final
        return string.format(" %s %s %s%s ", number, icon, name, modified), hl
      end,
    },

    config = function(_, opts)
      require("mini.tabline").setup(opts)

      -- siempre visible (como bufferline)
      vim.o.showtabline = 2
    end,
  },
}
