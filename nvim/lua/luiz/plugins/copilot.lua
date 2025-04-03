return {
	"github/copilot.vim",
	lazy = false,
	config = function()
		-- tab for accepting suggestions
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
		vim.g.copilot_tab_fallback = ""

		-- use tab to accept suggestions
		vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

		-- addiction keymaps
		vim.api.nvim_set_keymap("i", "<C-o>", "<Plug>(copilot-next)", { silent = true })
		vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>(copilot-previous)", { silent = true })
		vim.api.nvim_set_keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", { silent = true })
	end,
}
