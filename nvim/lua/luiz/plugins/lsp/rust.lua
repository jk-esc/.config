-- Rust support via rustaceanvim, using the rust-analyzer from the rustup
-- toolchain (`rustup component add rust-analyzer`, always matches rustc). Like
-- java.lua, kept out of the mason-lspconfig flow: rust_analyzer is excluded
-- from automatic_enable in mason.lua and its lifecycle is owned by rustaceanvim.
-- Debugging uses mason's codelldb, which rustaceanvim detects on its own.
return {
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false, -- the plugin lazy-loads itself on rust files
		init = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(_, bufnr)
						local map = function(lhs, subcommand, desc)
							vim.keymap.set("n", lhs, function()
								vim.cmd.RustLsp(subcommand)
							end, { buffer = bufnr, silent = true, desc = desc })
						end

						-- Rust-specific actions (<leader>R...)
						map("<leader>Rr", "runnables", "Rust: Runnables")
						map("<leader>Rt", "testables", "Rust: Testables")
						map("<leader>Rd", "debuggables", "Rust: Debuggables")
						map("<leader>Rm", "expandMacro", "Rust: Expand macro")
						map("<leader>Re", { "explainError", "current" }, "Rust: Explain error")
						map("<leader>Rh", { "hover", "actions" }, "Rust: Hover actions")
						map("<leader>Ra", "codeAction", "Rust: Grouped code actions")
						map("<leader>Rc", "openCargo", "Rust: Open Cargo.toml")
					end,
					default_settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" }, -- lint with clippy on save
						},
					},
				},
			}
		end,
	},
	{
		-- Cargo.toml: crate version completion, hover and upgrade actions
		"saecki/crates.nvim",
		tag = "stable",
		event = { "BufRead Cargo.toml" },
		opts = {
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
}
