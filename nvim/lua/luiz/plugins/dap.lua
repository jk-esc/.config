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
}
