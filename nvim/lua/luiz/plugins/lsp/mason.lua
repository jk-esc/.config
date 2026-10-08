return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Server overrides merge onto nvim-lspconfig's lsp/<name>.lua defaults.
		-- blink.cmp registers its completion capabilities on vim.lsp.config("*").
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})

		---@diagnostic disable-next-line: missing-fields
		mason_lspconfig.setup({
			-- automatic_enable starts every *installed* Mason server, so exclude:
			-- jdtls (managed by nvim-jdtls in lua/luiz/plugins/lsp/java.lua),
			-- pylsp (pyright + ruff cover python), stylua (conform formats lua).
			automatic_enable = {
				exclude = { "jdtls", "pylsp", "stylua" },
			},
			-- list of servers for mason to install
			ensure_installed = {
				"lua_ls",
				"clangd",
				"pyright",
				"bashls",
				-- web dev
				"ts_ls",
				"svelte",
				"html",
				"cssls",
				"eslint",
				"tailwindcss",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"ruff", -- python linter (auto-enabled as an LSP) + formatter
				"debugpy", -- python debugger
				-- java (driven by nvim-jdtls, not mason-lspconfig)
				"jdtls", -- java language server
				"java-debug-adapter", -- debugging bundle
				"java-test", -- test-running bundle
			},
		})
	end,
}
