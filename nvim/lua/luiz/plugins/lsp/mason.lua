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

		-- clang-tidy lints + detailed completion items. Projects beyond single
		-- files need a compile_commands.json (cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
		-- or `bear -- make`) so clangd knows the include paths/flags.
		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--header-insertion=iwyu",
			},
		})

		-- pyright owns hover for python; ruff's duplicate hover only adds noise
		vim.lsp.config("ruff", {
			on_attach = function(client)
				client.server_capabilities.hoverProvider = false
			end,
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

		-- ts_ls only sends inlay hints when these preferences are set
		local ts_inlay_hints = {
			includeInlayParameterNameHints = "literals",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = false,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		}
		vim.lsp.config("ts_ls", {
			settings = {
				typescript = { inlayHints = ts_inlay_hints },
				javascript = { inlayHints = ts_inlay_hints },
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
			-- rust_analyzer (managed by rustaceanvim in lua/luiz/plugins/lsp/rust.lua),
			-- pylsp (pyright + ruff cover python), stylua (conform formats lua).
			automatic_enable = {
				exclude = { "jdtls", "rust_analyzer", "pylsp", "stylua" },
			},
			-- list of servers for mason to install
			ensure_installed = {
				"lua_ls",
				"clangd",
				"neocmake", -- CMakeLists.txt
				"pyright",
				"bashls",
				"copilot", -- AI inline completions (sign in with :LspCopilotSignIn)
				"gopls",
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
				"js-debug-adapter", -- js/ts debugger (node + chrome)
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
