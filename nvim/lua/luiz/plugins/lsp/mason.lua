return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"b0o/SchemaStore.nvim", -- json/yaml schemas for jsonls + yamlls
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

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					gofumpt = true,
					staticcheck = true,
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})

		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					check = { command = "clippy" }, -- lint with clippy on save
				},
			},
		})

		-- package.json, tsconfig, GitHub workflows, docker-compose, ... validation
		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})
		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					schemaStore = { enable = false, url = "" }, -- use SchemaStore.nvim's catalog instead
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		})

		-- Copilot: inline completions + next-edit suggestions (sidekick.nvim).
		-- Never attach to .env files so secrets aren't sent as context.
		vim.lsp.config("copilot", {
			root_dir = function(bufnr, on_dir)
				if not vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)):match("^%.env") then
					on_dir(vim.fs.root(bufnr, ".git") or vim.fn.getcwd())
				end
			end,
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
				"copilot", -- AI inline completions (sign in with :LspCopilotSignIn)
				"gopls",
				"rust_analyzer",
				"taplo", -- toml (Cargo.toml)
				-- web dev
				"ts_ls",
				"svelte",
				"html",
				"cssls",
				"eslint",
				"tailwindcss",
				"emmet_language_server",
				"jsonls",
				"yamlls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"prettierd", -- prettier daemon (faster format on save)
				"stylua", -- lua formatter
				"ruff", -- python linter (auto-enabled as an LSP) + formatter
				"debugpy", -- python debugger
				-- go
				"goimports", -- import fixer + formatter
				"gofumpt", -- stricter gofmt
				"delve", -- go debugger
				"codelldb", -- c/c++/rust debugger
				-- java (driven by nvim-jdtls, not mason-lspconfig)
				"jdtls", -- java language server
				"java-debug-adapter", -- debugging bundle
				"java-test", -- test-running bundle
			},
		})
	end,
}
