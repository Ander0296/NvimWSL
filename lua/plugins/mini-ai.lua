
return {
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")

      return {
        n_lines = 500,

        custom_textobjects = {
          -- bloque lógico: if / for / while / {}
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),

          -- función
          f = ai.gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          }),

          -- clase
          c = ai.gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
          }),

          -- tags html/jsx/vue
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },

          -- número
          d = { "%f[%d]%d+" },

          -- palabra camelCase / snake / etc
          e = {
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },

          -- llamada de función (args)
          u = ai.gen_spec.function_call(),

          -- llamada sin punto (foo() no obj.foo())
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),

          -- buffer completo (equivalente a LazyVim)
          g = function()
            local from = { line = 1, col = 1 }
            local to = { line = vim.fn.line("$"), col = 1 }
            return { from = from, to = to }
          end,
        },
      }
    end,

    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
