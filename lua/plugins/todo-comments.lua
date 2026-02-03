-- TODO:
return {
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

-- NOTE:
    -- LazyVim usa LazyFile (no existe en lazy.nvim puro)
    -- usamos eventos reales:
    event = { "BufReadPost", "BufNewFile" },

    cmd = { "TodoTrouble", "TodoTelescope" },

    keys = {
      -- navegación rápida
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Prev Todo",
      },

      -- Trouble
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todos (Trouble)" },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>",
        desc = "Todos importantes",
      },

      -- Telescope
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todos (Telescope)" },
      {
        "<leader>sT",
        "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
        desc = "Todos importantes",
      },
    },

    opts = {
      highlight = {
        comments_only = true, -- más rápido
      },

      keywords = {
        TODO = { icon = " ", color = "info" },
        FIX = { icon = " ", color = "error" },
        FIXME = { icon = " ", color = "error" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning" },
        PERF = { icon = " ", color = "hint" },
        NOTE = { icon = " ", color = "hint" },
      },
    },
  },
}
