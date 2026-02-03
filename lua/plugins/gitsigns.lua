return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },

      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        -- Navegar hunks
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Siguiente hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Hunk anterior")

        map("n", "]H", function() gs.nav_hunk("last") end, "Último hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "Primer hunk")

        -- Acciones hunks
        map({ "n", "x" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk")
        map({ "n", "x" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Deshacer stage hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")

        -- Vista / blame / diff
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Previsualizar hunk (inline)")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame línea (full)")
        map("n", "<leader>ghB", gs.blame, "Blame buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff este archivo")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff vs ~")

        -- Textobject: seleccionar hunk
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Seleccionar hunk")
      end,
    },
  },
}
