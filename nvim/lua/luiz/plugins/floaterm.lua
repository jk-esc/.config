return {
	{
		"voldikss/vim-floaterm",
		--lazy = false, -- preload to avoid delay
		--url = "git@github.com:voldikss/vim-floaterm.git",
		config = function()
			vim.g.floaterm_title = " typeshit "
		end,
	},
}
