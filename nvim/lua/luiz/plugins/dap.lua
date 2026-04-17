return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = { "<leader>db", "<leader>dB", "<leader>dc", "<leader>di", "<leader>do", "<leader>dO", "<leader>dr", "<leader>du", "<leader>dt" },
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
			keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set conditional breakpoint" })
			keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
			keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
			keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
			keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
			keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
			keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
			keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate session" })
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		config = function()
			-- Uses the debugpy installed by mason
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(mason_path)

			-- Additional python-specific keymaps
			local keymap = vim.keymap
			keymap.set("n", "<leader>dm", require("dap-python").test_method, { desc = "Debug test method" })
			keymap.set("n", "<leader>dC", require("dap-python").test_class, { desc = "Debug test class" })
			keymap.set("v", "<leader>ds", require("dap-python").debug_selection, { desc = "Debug selection" })
		end,
	},
}
