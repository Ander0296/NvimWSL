return {
	-- Core DAP
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- UI
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				opts = {},
				keys = {
					{
						"<leader>du",
						function()
							require("dapui").toggle({})
						end,
						desc = "DAP: Alternar UI",
					},
					{
						"<leader>de",
						function()
							require("dapui").eval()
						end,
						mode = { "n", "x" },
						desc = "DAP: Evaluar expresión",
					},
				},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)

					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},
			-- Virtual text
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
			-- Installer de adapters (opcional, recomendado)
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "williamboman/mason.nvim" },
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					automatic_installation = true,
					handlers = {},
					ensure_installed = {
						"java-debug-adapter",
						"java-test",
						"python",
					},
				},
				config = function(_, opts)
					require("mason-nvim-dap").setup(opts)
				end,
			},
		},

		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Condición breakpoint: "))
				end,
				desc = "DAP: Breakpoint condicional",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "DAP: Alternar breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "DAP: Ejecutar/Continuar",
			},
			{
				"<leader>da",
				function()
					local dap = require("dap")
					local args = vim.fn.input("Args: ")
					dap.continue({
						before = function()
							return vim.split(args, "%s+")
						end,
					})
				end,
				desc = "DAP: Ejecutar con args",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "DAP: Correr hasta cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "DAP: Ir a línea (sin ejecutar)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "DAP: Step Into",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "DAP: Step Over",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "DAP: Step Out",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "DAP: Bajar frame",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "DAP: Subir frame",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "DAP: Repetir último",
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "DAP: Pausar",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "DAP: Alternar REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "DAP: Sesión",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "DAP: Terminar",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "DAP: Widgets hover",
			},
		},

		config = function()
			local dap = require("dap")

			-- Signos (sin LazyVim)
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapLogPoint", { text = "▶", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticInfo", linehl = "DapStoppedLine" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "✗", texthl = "DiagnosticHint" })

			-- launch.json con comentarios (/* */ y //)
			local ok_vscode, vscode = pcall(require, "dap.ext.vscode")
			if ok_vscode then
				local ok_json, plenary_json = pcall(require, "plenary.json")
				if ok_json then
					vscode.json_decode = function(str)
						return vim.json.decode(plenary_json.json_strip_comments(str))
					end
				end
			end
		end,
	},
}
