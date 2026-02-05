return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- usar HEAD
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (vim.fn.executable("cmake") == 1)
            and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
          or (vim.fn.executable("make") == 1 and "make" or nil),
        enabled = (vim.fn.executable("cmake") == 1) or (vim.fn.executable("make") == 1),
      },
    },

    -- =========================
    -- KEYMAPS
    -- =========================
    keys = function()
      local builtin = require("telescope.builtin")

      local function project_root()
        local buf = vim.api.nvim_buf_get_name(0)
        local path = (buf ~= "" and vim.fs.dirname(buf)) or vim.uv.cwd()
        local root = vim.fs.root(path, { ".git", "Makefile", "package.json", "pyproject.toml", "go.mod" })
        return root or vim.uv.cwd()
      end

      local function config_root()
        return vim.fn.stdpath("config")
      end

      local function lazy_root()
        return vim.fn.stdpath("data") .. "/lazy"
      end

      local function get_visual_selection()
        local _, ls, cs = unpack(vim.fn.getpos("v"))
        local _, le, ce = unpack(vim.fn.getpos("."))
        if ls > le or (ls == le and cs > ce) then
          ls, le = le, ls
          cs, ce = ce, cs
        end
        local lines = vim.fn.getline(ls, le)
        if #lines == 0 then
          return ""
        end
        lines[1] = string.sub(lines[1], cs)
        lines[#lines] = string.sub(lines[#lines], 1, ce)
        return table.concat(lines, "\n")
      end

      return {
        -- buffers / comandos
        {
          "<leader>,",
          function()
            builtin.buffers({ sort_mru = true, sort_lastused = true })
          end,
          desc = "Cambiar buffer",
        },
        { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Historial de comandos" },

        -- find (root / cwd)
        {
          "<leader><space>",
          function()
            builtin.find_files({ cwd = project_root() })
          end,
          desc = "Buscar archivos (raíz del proyecto)",
        },
        {
          "<leader>ff",
          function()
            builtin.find_files({ cwd = project_root() })
          end,
          desc = "Buscar archivos (raíz del proyecto)",
        },
        {
          "<leader>fF",
          function()
            builtin.find_files({ cwd = vim.uv.cwd() })
          end,
          desc = "Buscar archivos (directorio actual)",
        },
        { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Buscar archivos (git)" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recientes" },
        {
          "<leader>fR",
          function()
            builtin.oldfiles({ cwd = vim.uv.cwd() })
          end,
          desc = "Recientes (directorio actual)",
        },

        -- buffers
        {
          "<leader>fb",
          function()
            builtin.buffers({
              sort_mru = true,
              sort_lastused = true,
              ignore_current_buffer = true,
            })
          end,
          desc = "Buffers",
        },
        { "<leader>fB", "<cmd>Telescope buffers<cr>", desc = "Buffers (todos)" },

        -- config
        {
          "<leader>fc",
          function()
            builtin.find_files({ cwd = config_root() })
          end,
          desc = "Buscar archivo de configuración",
        },

        -- plugins (lazy root)
        {
          "<leader>fp",
          function()
            builtin.find_files({ cwd = lazy_root() })
          end,
          desc = "Buscar archivo de plugin",
        },

        -- git
        { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
        { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
        { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Estado" },
        { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git stash" },

        -- search
        { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registros" },
        { "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Historial de búsqueda" },
        { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Autocomandos" },
        { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Líneas del buffer" },
        { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Historial de comandos" },
        { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Comandos" },
        { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnósticos" },
        { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Diagnósticos del buffer" },
        {
          "<leader>sg",
          function()
            builtin.live_grep({ cwd = project_root() })
          end,
          desc = "Buscar texto (raíz del proyecto)",
        },
        {
          "<leader>sG",
          function()
            builtin.live_grep({ cwd = vim.uv.cwd() })
          end,
          desc = "Buscar texto (directorio actual)",
        },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Ayuda" },
        { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Grupos de highlight" },
        { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Lista de saltos" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Atajos de teclado" },
        { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Lista de ubicación" },
        { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Ir a marca" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Opciones" },
        { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Reanudar búsqueda" },
        { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Lista quickfix" },

        -- palabra / selección (root / cwd)
        {
          "<leader>sw",
          function()
            builtin.grep_string({ cwd = project_root(), word_match = "-w" })
          end,
          desc = "Palabra (raíz del proyecto)",
        },
        {
          "<leader>sW",
          function()
            builtin.grep_string({ cwd = vim.uv.cwd(), word_match = "-w" })
          end,
          desc = "Palabra (directorio actual)",
        },
        {
          "<leader>sw",
          mode = "x",
          function()
            local text = get_visual_selection()
            builtin.grep_string({ cwd = project_root(), search = text })
          end,
          desc = "Selección (raíz del proyecto)",
        },
        {
          "<leader>sW",
          mode = "x",
          function()
            local text = get_visual_selection()
            builtin.grep_string({ cwd = vim.uv.cwd(), search = text })
          end,
          desc = "Selección (directorio actual)",
        },

        -- colores
        {
          "<leader>uC",
          function()
            builtin.colorscheme({ enable_preview = true })
          end,
          desc = "Colores con vista previa",
        },

        -- LSP símbolos
        {
          "<leader>ss",
          function()
            builtin.lsp_document_symbols()
          end,
          desc = "Ir a símbolo",
        },
        {
          "<leader>sS",
          function()
            builtin.lsp_dynamic_workspace_symbols()
          end,
          desc = "Ir a símbolo (workspace)",
        },
      }
    end,

    -- =========================
    -- OPCIONES + INTEGRACIONES
    -- =========================
    opts = function()
      local actions = require("telescope.actions")

      local function project_root()
        local buf = vim.api.nvim_buf_get_name(0)
        local path = (buf ~= "" and vim.fs.dirname(buf)) or vim.uv.cwd()
        local root = vim.fs.root(path, { ".git", "Makefile", "package.json", "pyproject.toml", "go.mod" })
        return root or vim.uv.cwd()
      end

      local function find_command()
        if vim.fn.executable("rg") == 1 then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif vim.fn.executable("fd") == 1 then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif vim.fn.executable("fdfind") == 1 then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif vim.fn.executable("find") == 1 and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif vim.fn.executable("where") == 1 then
          return { "where", "/r", ".", "*" }
        end
      end

      local function open_with_trouble(...)
        local ok, trouble = pcall(require, "trouble.sources.telescope")
        if ok then
          return trouble.open(...)
        end
      end

      local function flash(prompt_bufnr)
        local ok_flash, flash_mod = pcall(require, "flash")
        if not ok_flash then
          return
        end
        flash_mod.jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end

      local function find_files_no_ignore(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({
          cwd = project_root(),
          no_ignore = true,
          default_text = line,
        })
      end

      local function find_files_with_hidden(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({
          cwd = project_root(),
          hidden = true,
          default_text = line,
        })
      end

      return {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0,

          prompt_prefix = " ",
          selection_caret = " ",

          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,

          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_with_trouble,

              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,

              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,

              ["<c-s>"] = flash,
            },
            n = {
              ["q"] = actions.close,
              ["s"] = flash,
            },
          },
        },

        pickers = {
          find_files = {
            find_command = find_command,
            hidden = true,
          },
        },
      }
    end,

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
