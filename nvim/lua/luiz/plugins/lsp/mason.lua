return {
	"williamboman/mason.nvim",
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
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		---@diagnostic disable-next-line: missing-fields
		mason_lspconfig.setup({
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
			},
		})
	end,
}
