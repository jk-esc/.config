return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Hunks" },
			{ "<leader>s", group = "Splits" },
			{ "<leader>t", group = "Tabs" },
			{ "<leader>d", group = "Debug/Diagnostics" },
			{ "<leader>j", group = "Java" },
			{ "<leader>r", group = "Rename/Restart" },
			{ "<leader>c", group = "Code" },
		},
	},
}
