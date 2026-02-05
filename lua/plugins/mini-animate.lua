
return {
  {
    "nvim-mini/mini.animate",
    event = "VeryLazy",
    cond = vim.g.neovide == nil, -- no animar en neovide

    opts = function()
      -- no animar cuando haces scroll con el mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true, silent = true })
      end

      -- desactivar en este filetype (ej grug-far)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "grug-far",
        callback = function()
          vim.b.minianimate_disable = true
        end,
      })

      local animate = require("mini.animate")

      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,

    config = function(_, opts)
      require("mini.animate").setup(opts)

      -- Toggle global (sin Snacks)
      vim.g.minianimate_disable = vim.g.minianimate_disable or false
      vim.keymap.set("n", "<leader>ua", function()
        vim.g.minianimate_disable = not vim.g.minianimate_disable
        if vim.g.minianimate_disable then
          vim.notify("Mini Animate: OFF")
        else
          vim.notify("Mini Animate: ON")
        end
      end, { desc = "UI: Alternar animaciones" })
    end,
  },
}
