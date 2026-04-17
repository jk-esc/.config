return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
	},
	ft = "python",
	config = function()
		require("venv-selector").setup({
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		})

		vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<CR>", { desc = "Select Python venv" })
		vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<CR>", { desc = "Select cached Python venv" })
	end,
}
