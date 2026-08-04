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

		local lspconfig = require("lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		---@diagnostic disable-next-line: missing-fields
		mason_lspconfig.setup({
			-- jdtls is managed by nvim-jdtls (lua/luiz/plugins/lsp/java.lua),
			-- so don't let mason-lspconfig auto-start a second one.
			automatic_enable = {
				exclude = { "jdtls" },
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
			handlers = {
				-- default handler
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								completion = { callSnippet = "Replace" },
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
							},
						},
					})
				end,
				-- svelte needs to know about ts files for cross-file awareness
				["svelte"] = function()
					lspconfig.svelte.setup({
						capabilities = capabilities,
						on_attach = function(client, _)
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"ruff", -- python linter + formatter
				"debugpy", -- python debugger
				"eslint_d", -- js/ts linter
				-- java (driven by nvim-jdtls, not mason-lspconfig)
				"jdtls", -- java language server
				"java-debug-adapter", -- debugging bundle
				"java-test", -- test-running bundle
			},
		})
	end,
}
