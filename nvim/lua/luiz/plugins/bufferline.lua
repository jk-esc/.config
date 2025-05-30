--[[return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			--separator_style = "slant",
		},
	},
}]]

-- In your bufferline.nvim plugin specification (e.g., lua/luiz/plugins/bufferline.lua)
return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	event = "VeryLazy", -- Or "BufReadPre" / "BufNewFile"
	opts = {
		options = {
			mode = "tabs",
			separator_style = "thin",
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)
	end,
}
