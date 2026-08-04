-- Java support via nvim-jdtls (Eclipse JDT language server).
-- Kept out of the mason-lspconfig handler flow on purpose: jdtls needs
-- per-project workspace handling and its own start/attach lifecycle, so it is
-- excluded from automatic_enable in mason.lua and driven entirely from here.
return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	dependencies = {
		"mfussenegger/nvim-dap", -- debugging via the java-debug-adapter bundle
	},
	config = function()
		local jdtls = require("jdtls")

		local mason = vim.fn.stdpath("data") .. "/mason"
		local jdtls_bin = mason .. "/bin/jdtls"

		-- Resolve a valid JDK home by major version (macOS java_home).
		-- Guards against a stale/broken $JAVA_HOME in the shell.
		local function java_home(version)
			local handle = io.popen("/usr/libexec/java_home -v " .. version .. " 2>/dev/null")
			if not handle then
				return nil
			end
			local path = handle:read("*a"):gsub("%s+$", "")
			handle:close()
			return path ~= "" and path or nil
		end

		local jdk21 = java_home("21")
		local jdk25 = java_home("25")

		-- Run the language server itself on a stable LTS if available.
		local server_jdk = jdk21 or jdk25
		if server_jdk then
			vim.env.JAVA_HOME = server_jdk
		end

		-- Expose installed JDKs so projects resolve source/target levels.
		local runtimes = {}
		if jdk21 then
			table.insert(runtimes, { name = "JavaSE-21", path = jdk21, default = true })
		end
		if jdk25 then
			table.insert(runtimes, { name = "JavaSE-25", path = jdk25 })
		end

		-- Debug + test bundles (installed via mason: java-debug-adapter, java-test).
		local bundles = {}
		vim.list_extend(
			bundles,
			vim.split(
				vim.fn.glob(
					mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
					true
				),
				"\n"
			)
		)
		vim.list_extend(
			bundles,
			vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", true), "\n")
		)
		bundles = vim.tbl_filter(function(v)
			return v ~= ""
		end, bundles)

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local function start()
			local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", "settings.gradle", ".git" }
			local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()

			-- One workspace per project keeps jdtls indexes isolated.
			local project = vim.fn.fnamemodify(root_dir, ":p:h:t")
			local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project

			local config = {
				cmd = { jdtls_bin, "-data", workspace },
				root_dir = root_dir,
				capabilities = capabilities,
				init_options = { bundles = bundles },
				settings = {
					java = {
						eclipse = { downloadSources = true },
						maven = { downloadSources = true },
						configuration = {
							updateBuildConfiguration = "interactive",
							runtimes = runtimes,
						},
						references = { includeDecompiledSources = true },
						implementationsCodeLens = { enabled = true },
						referencesCodeLens = { enabled = true },
						signatureHelp = { enabled = true },
						format = { enabled = true },
						inlayHints = { parameterNames = { enabled = "all" } },
						completion = {
							favoriteStaticMembers = {
								"org.junit.jupiter.api.Assertions.*",
								"org.junit.Assert.*",
								"org.mockito.Mockito.*",
								"java.util.Objects.requireNonNull",
							},
						},
						sources = {
							organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
						},
					},
				},
				on_attach = function(_, bufnr)
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
					end

					-- Refactoring / Java-specific actions (<leader>j...)
					map("n", "<leader>jo", jdtls.organize_imports, "Java: Organize imports")
					map("n", "<leader>jv", jdtls.extract_variable, "Java: Extract variable")
					map("v", "<leader>jv", function()
						jdtls.extract_variable(true)
					end, "Java: Extract variable")
					map("n", "<leader>jx", jdtls.extract_constant, "Java: Extract constant")
					map("v", "<leader>jx", function()
						jdtls.extract_constant(true)
					end, "Java: Extract constant")
					map("v", "<leader>jm", function()
						jdtls.extract_method(true)
					end, "Java: Extract method")

					-- Testing (needs the java-test bundle)
					map("n", "<leader>jn", jdtls.test_nearest_method, "Java: Test nearest method")
					map("n", "<leader>jc", jdtls.test_class, "Java: Test class")

					-- Rebuild project config after editing pom.xml / build.gradle
					map("n", "<leader>ju", "<cmd>JdtUpdateConfig<CR>", "Java: Update project config")

					-- Debugging (needs the java-debug-adapter bundle)
					jdtls.setup_dap({ hotcodereplace = "auto" })
					require("jdtls.dap").setup_dap_main_class_configs()
				end,
			}

			jdtls.start_or_attach(config)
		end

		-- Attach to Java buffers opened later...
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = start,
		})
		-- ...and to the buffer that triggered this (lazy) load.
		start()
	end,
}
