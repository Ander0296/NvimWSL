return {
  -- Mason (instalador)
  {
    "williamboman/mason.nvim",
    cmd = { "Mason" },
    opts = {},
  },

  -- Puente mason <-> lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
      -- ensure_installed = { "lua_ls", "pyright", "jdtls", "vtsls" },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },

    config = function()
      -- =========================
      -- 1) Diagnostics (global)
      -- =========================
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      })
      -- =========================
      -- 2) Keymaps por buffer (LspAttach)
      -- =========================
      local function map(buf, mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("MyLspKeymaps", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end

          local function has(method)
            return client.supports_method(method)
          end

          -- Navegación
          map(buf, "n", "gd", vim.lsp.buf.definition, "Ir a definición")
          map(buf, "n", "gD", vim.lsp.buf.declaration, "Ir a declaración")
          map(buf, "n", "gI", vim.lsp.buf.implementation, "Ir a implementación")
          map(buf, "n", "gy", vim.lsp.buf.type_definition, "Ir a tipo (type definition)")
          map(buf, "n", "gr", vim.lsp.buf.references, "Referencias")

          -- Ayuda
          map(buf, "n", "K", vim.lsp.buf.hover, "Hover (documentación)")
          if has("textDocument/signatureHelp") then
            map(buf, "n", "gK", vim.lsp.buf.signature_help, "Ayuda de firma")
            map(buf, "i", "<C-k>", vim.lsp.buf.signature_help, "Ayuda de firma")
          end

          -- Acciones / renombrar
          if has("textDocument/codeAction") then
            map(buf, { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Acción de código")
          end
          if has("textDocument/rename") then
            map(buf, "n", "<leader>cr", vim.lsp.buf.rename, "Renombrar símbolo")
          end

          -- Inlay hints
          if vim.lsp.inlay_hint and has("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            map(buf, "n", "<leader>uh", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
            end, "Alternar inlay hints")
          end

          -- Info del LSP (Snacks o LspInfo)
          map(buf, "n", "<leader>cl", function()
            local ok, Snacks = pcall(require, "snacks")
            if ok and Snacks.picker and Snacks.picker.lsp_config then
              Snacks.picker.lsp_config()
            else
              vim.cmd("LspInfo")
            end
          end, "Info del LSP")
        end,
      })

      -- =========================
      -- 3) Servers (los tuyos)
      -- =========================
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              hint = {
                enable = true,
                paramType = true,
                paramName = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },

        vtsls = {},
        pyright = {},
        jdtls = {},
      }

      -- =========================
      -- 4) Capabilities (blink.cmp) + registrar servers (API 0.11+)
      -- =========================
      local blink = require("blink.cmp")
      local base_caps = vim.lsp.protocol.make_client_capabilities()
      local caps = blink.get_lsp_capabilities(base_caps)

      for name, cfg in pairs(servers) do
        cfg = cfg or {}
        cfg.capabilities = vim.tbl_deep_extend("force", {}, caps, cfg.capabilities or {})

        -- Registra config del server (nvim-lspconfig aporta defaults internos)
        vim.lsp.config(name, cfg)
        -- Habilita el server
        vim.lsp.enable(name)
      end

      -- =========================
      -- 5) Keymap extra: Organize Imports (LSP)
      -- =========================
      vim.keymap.set("n", "<leader>co", function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { "source.organizeImports" },
            diagnostics = {},
          },
        })
      end, { desc = "Organizar imports (LSP)" })
    end,
  },
}
