return {
	"navarasu/onedark.nvim",
	--priority = 1000,
	config = function()
		local onedark = require("onedark")

		onedark.setup({
			style = "dark",
			transparent = true,
			term_colors = true,
			ending_tildes = false,
			cmp_itemkind_reverse = false,
			code_style = {
				comments = "italic",
				keywords = "none",
				functions = "none",
				strings = "none",
				variables = "none",
			},
			lualine = {
				transparent = true,
			},

			-- Explicit highlight overrides
			highlights = {
				-- For Bufferline transparency
				BufferLineFill = { bg = "none" },
				BufferLineBackground = { bg = "none" },
				BufferLineBufferSelected = { bg = "none", fg = "$cyan", bold = true },
				BufferLineBufferVisible = { bg = "none", fg = "$grey" },
				BufferLineTabSelected = { bg = "none", fg = "$cyan", bold = true },
				BufferLineTab = { bg = "none", fg = "$grey" },
				BufferLineTabClose = { bg = "none" }, -- Removed fg = "$dark_grey"

				-- For Floaterm and general Float window transparency
				NormalFloat = { bg = "none" },
				FloatBorder = { bg = "none", fg = "$blue" },

				-- comments
				["@comment"] = { fg = "#cccccc" },
				["@lsp.type.comment"] = { fg = "cccccc" },

				-- Visual mode
				Visual = { bg = "#6c7a8a" },

				-- Ensure other common UI elements respect transparency too
				Pmenu = { bg = "none", fg = "$fg" },
				PmenuSel = { bg = "$blue" },
				PmenuThumb = { bg = "$blue" },
				StatusLine = { bg = "none", fg = "$grey" },
				StatusLineNC = { bg = "none" },
				TabLineFill = { bg = "none" },
				WinSeparator = { fg = "$blue", bg = "none" },
				MatchParen = { bg = "none" },
			},
		})
		vim.cmd("colorscheme onedark")
	end,
}
