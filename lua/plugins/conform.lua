return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		cmd = { "ConformInfo" },

		keys = {
			-- Formatear archivo/selección (lo típico)
			{
				"<leader>cf",
				function()
					require("conform").format({
						timeout_ms = 3000,
						lsp_format = "fallback",
					})
				end,
				mode = { "n", "x" },
				desc = "Formatear",
			},

			-- Formatear lenguajes inyectados (JS/CSS dentro de HTML/MD, etc.)
			{
				"<leader>cF",
				function()
					require("conform").format({
						formatters = { "injected" },
						timeout_ms = 3000,
					})
				end,
				mode = { "n", "x" },
				desc = "Formatear lenguajes inyectados",
			},
		},

		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_format = "fallback",
			},

			-- qué formatter usar por filetype
			formatters_by_ft = {
				lua = { "stylua" },
				fish = { "fish_indent" },
				sh = { "shfmt" },
                java = {"google-java-format"},
				python = { "ruff_format" }, -- o "black"
				-- ejemplos comunes (actívalos si los usas)
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- json = { "prettier" },
				-- yaml = { "prettier" },
			},

			formatters = {
				injected = { options = { ignore_errors = true } },

				-- Ejemplo: usar dprint solo si existe dprint.json
				-- dprint = {
				--   condition = function(ctx)
				--     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
				--   end,
				-- },

				-- Ejemplo: shfmt con args extra
				-- shfmt = {
				--   prepend_args = { "-i", "2", "-ci" },
				-- },
			},
		},
	},
}
