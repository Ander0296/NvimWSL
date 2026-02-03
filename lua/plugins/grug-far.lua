
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },

    opts = {
      headerMaxWidth = 80,
      transient = true,
    },

    keys = {
      -- 🔁 Reemplazar en TODO el proyecto
      {
        "<leader>rr",
        "<cmd>GrugFar<cr>",
        desc = "Reemplazar en proyecto",
      },

      -- 🔁 Reemplazar solo en el archivo actual
      {
        "<leader>rf",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            vim.notify("No hay archivo actual para limitar la búsqueda", vim.log.levels.WARN)
            return
          end

          require("grug-far").open({
            prefills = {
              paths = file, -- ✅ string (NO tabla)
            },
          })
        end,
        desc = "Reemplazar en archivo actual",
      },

      -- 🔁 Reemplazar por extensión (.ts, .lua, etc)
      {
        "<leader>re",
        function()
          local ext = vim.fn.expand("%:e")
          require("grug-far").open({
            prefills = {
              filesFilter = (ext ~= "" and "*." .. ext) or nil,
            },
          })
        end,
        desc = "Reemplazar por extensión",
      },
    },
  },
}
