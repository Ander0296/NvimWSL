
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },

    opts = {
      -- Eventos que disparan lint
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },

      linters_by_ft = {
        fish = { "fish" },
        python = { "ruff" },
        -- ["*"] = { "typos" }, -- linter global para todos los filetypes
        -- ["_"] = { "fallback" }, -- fallback si no hay linter por ft
      },

      -- Sobrescribir/crear linters y/o añadir condiciones
      -- (misma idea que LazyVim, pero vanilla)
      linters = {
        -- Ejemplo: selene solo si existe selene.toml
        -- selene = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },

    config = function(_, opts)
      local lint = require("lint")

      -- Merge de linters custom en lint.linters
      for name, linter in pairs(opts.linters or {}) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end

      lint.linters_by_ft = opts.linters_by_ft or {}

      -- Debounce simple
      local function debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule(function()
              fn(unpack(argv))
            end)
          end)
        end
      end

      -- Función principal de lint
      local function do_lint()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        names = vim.list_extend({}, names)

        -- fallback "_" si no hay linters por ft
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        -- global "*" siempre
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        -- filtrar linters inexistentes o que no cumplan condition
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            vim.notify(("Linter no encontrado: %s"):format(name), vim.log.levels.WARN, { title = "nvim-lint" })
            return false
          end
          if type(linter) == "table" and type(linter.condition) == "function" then
            return linter.condition(ctx)
          end
          return true
        end, names)

        if #names > 0 then
          lint.try_lint(names)
        end
      end

      -- Autocmds
      local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd(opts.events, {
        group = group,
        callback = debounce(100, do_lint),
      })

      -- Comando manual útil
      vim.api.nvim_create_user_command("Lint", do_lint, { desc = "Ejecutar linters (nvim-lint)" })
    end,
  },
}
