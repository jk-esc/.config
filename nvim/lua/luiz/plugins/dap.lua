return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = { "<leader>bb", "<leader>bB", "<leader>bc", "<leader>bi", "<leader>bo", "<leader>bO", "<leader>br", "<leader>bu", "<leader>bt" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			require("nvim-dap-virtual-text").setup()

			-- Auto open/close dapui with debug sessions
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- C/C++/Rust via the codelldb installed by mason
			dap.adapters.codelldb = {
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			}
			local codelldb = {
				{
					name = "Launch executable",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.c = codelldb
			dap.configurations.cpp = codelldb
			dap.configurations.rust = codelldb

			-- JS/TS (node + chrome) via the js-debug-adapter installed by mason
			for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
				dap.adapters[adapter] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
						args = { "${port}" },
					},
				}
			end
			local js = {
				{
					name = "Launch file (node)",
					type = "pwa-node",
					request = "launch",
					program = "${file}", -- node 23.6+ runs .ts files directly
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
				{
					name = "Attach to node process",
					type = "pwa-node",
					request = "attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Launch Chrome",
					type = "pwa-chrome",
					request = "launch",
					url = function()
						return vim.fn.input("URL: ", "http://localhost:5173")
					end,
					webRoot = "${workspaceFolder}",
				},
			}
			for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" }) do
				dap.configurations[ft] = js
			end

			-- Keymaps
			local keymap = vim.keymap
			keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			keymap.set("n", "<leader>bB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set conditional breakpoint" })
			keymap.set("n", "<leader>bc", dap.continue, { desc = "Continue" })
			keymap.set("n", "<leader>bi", dap.step_into, { desc = "Step into" })
			keymap.set("n", "<leader>bo", dap.step_over, { desc = "Step over" })
			keymap.set("n", "<leader>bO", dap.step_out, { desc = "Step out" })
			keymap.set("n", "<leader>br", dap.repl.open, { desc = "Open REPL" })
			keymap.set("n", "<leader>bu", dapui.toggle, { desc = "Toggle DAP UI" })
			keymap.set("n", "<leader>bt", dap.terminate, { desc = "Terminate session" })
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		config = function()
			-- Uses the debugpy installed by mason
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			local dap_python = require("dap-python")
			dap_python.setup(mason_path)

			-- Additional python-specific keymaps, buffer-local so they don't
			-- shadow other languages' test keymaps
			local function set_keymaps(ev)
				local buf = ev and ev.buf or 0
				local keymap = vim.keymap
				keymap.set("n", "<leader>bm", dap_python.test_method, { buffer = buf, desc = "Debug test method" })
				keymap.set("n", "<leader>bC", dap_python.test_class, { buffer = buf, desc = "Debug test class" })
				keymap.set("v", "<leader>bs", dap_python.debug_selection, { buffer = buf, desc = "Debug selection" })
			end
			vim.api.nvim_create_autocmd("FileType", { pattern = "python", callback = set_keymaps })
			set_keymaps()
		end,
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "go",
		config = function()
			-- Uses the delve (dlv) installed by mason
			local dap_go = require("dap-go")
			dap_go.setup()

			-- Additional go-specific keymaps, buffer-local like the python ones
			local function set_keymaps(ev)
				local buf = ev and ev.buf or 0
				vim.keymap.set("n", "<leader>bm", dap_go.debug_test, { buffer = buf, desc = "Debug test method" })
				vim.keymap.set("n", "<leader>bl", dap_go.debug_last_test, { buffer = buf, desc = "Debug last test" })
			end
			vim.api.nvim_create_autocmd("FileType", { pattern = "go", callback = set_keymaps })
			set_keymaps()
		end,
	},
}
