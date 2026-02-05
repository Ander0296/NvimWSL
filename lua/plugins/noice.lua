
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    cmd = { "Noice" }, -- <-- CLAVE: ahora :Noice SIEMPRE existe y carga el plugin
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirigir cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Último mensaje (Noice)" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Historial (Noice)" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Todos los mensajes (Noice)" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Descartar todo (Noice)" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Selector (Telescope/FzfLua)" },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll adelante",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll atrás",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = { timeout = 3000, stages = "fade" },
    config = function(_, opts)
      local ok, notify = pcall(require, "notify")
      if ok then
        notify.setup(opts)
        vim.notify = notify
      end
    end,
  },
}
