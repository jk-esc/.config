return {
	{
		"voldikss/vim-floaterm",
		lazy = false, -- preload to avoid delay
		--url = "git@github.com:voldikss/vim-floaterm.git",
		config = function()
			vim.g.floaterm_title = " typeshit "
			-- Mapping <leader>ft to toggle Floaterm
			vim.api.nvim_set_keymap("n", "<leader>ft", ":FloatermToggle<CR>", { noremap = true, silent = true })
		end,
	},
}
