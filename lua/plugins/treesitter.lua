
return {
  -- 1) Treesitter (main): parsers + start
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local ts = require("nvim-treesitter")
      local languages = {
        "bash","c","diff","html","javascript","java","jsdoc","json","jsonc","lua","luadoc","luap",
        "markdown","markdown_inline","printf","python","query","regex","toml","tsx","typescript",
        "vim","vimdoc","xml","yaml",
      }

      -- instala (en main es async, por eso esperamos)
      ts.install(languages):wait(300000)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TS_Start", { clear = true }),
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then return end
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },

  -- 2) Incremental Selection (módulo extra)
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<Tab>",
          node_decremental = "<S-Tab>",
          scope_incremental = false,
        },
      },
    },
  },

  -- 3) Textobjects: MOVE (navegación por funciones/clases/parámetros)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },

    config = function()
      local ok, tx = pcall(require, "nvim-treesitter-textobjects")
      if not (ok and tx.setup) then
        return
      end

      tx.setup({
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
          },
        },
      })
    end,
  },
}
