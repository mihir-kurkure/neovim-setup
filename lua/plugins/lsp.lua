-- LSP Configuration & Plugins
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			--"j-hui/fidget.nvim",
			"folke/neodev.nvim",
			"RRethy/vim-illuminate",
			"hrsh7th/cmp-nvim-lsp",
			"nvim-lua/plenary.nvim",
			'mfussenegger/nvim-dap',
			"p00f/clangd_extensions.nvim",
		},
		config = function()
			-- Set up Mason before anything else
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					-- "pylsp",
					"rust_analyzer",
					"clangd",
				},
				automatic_installation = false,
			})

			-- Quick access via keymap
			require("helpers.keys").map("n", "<leader>M", "<cmd>Mason<cr>", "Show Mason")

			-- Neodev setup before LSP config
			require("neodev").setup()

			-- Turn on LSP status information
			--require("fidget").setup()

			-- Set up cool signs for diagnostics
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Diagnostic config
			local config = {
				virtual_text = true,
				signs = {
					active = signs,
				},
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			}
			vim.diagnostic.config(config)

			-- This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(client, bufnr)
				local lsp_map = require("helpers.keys").lsp_map

				lsp_map("<leader>lr", vim.lsp.buf.rename, bufnr, "Rename symbol")
				lsp_map("<leader>la", vim.lsp.buf.code_action, bufnr, "Code action")
				lsp_map("<leader>ld", vim.lsp.buf.type_definition, bufnr, "Type definition")
				lsp_map("<leader>ls", require("telescope.builtin").lsp_document_symbols, bufnr, "Document symbols")

				lsp_map("gd", vim.lsp.buf.definition, bufnr, "Goto Definition")
				lsp_map("gr", require("telescope.builtin").lsp_references, bufnr, "Goto References")
				lsp_map("gI", vim.lsp.buf.implementation, bufnr, "Goto Implementation")
				lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
				lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })

				lsp_map("<leader>ff", "<cmd>Format<cr>", bufnr, "Format")

				-- Attach and configure vim-illuminate
				require("illuminate").on_attach(client)
			end

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Lua
			require("lspconfig")["lua_ls"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			-- Python
			require("lspconfig")["pyright"].setup({
				on_attach = on_attach,
				-- settings = {
				-- 	pylsp = {
				-- 	plugins = {
				-- 		-- formatter options
				-- 		black = { enabled = true },
				-- 		autopep8 = { enabled = false },
				-- 		yapf = { enabled = false },
				-- 		-- linter options
				-- 		pylint = { enabled = true, executable = "pylint" },
				-- 		pyflakes = { enabled = false },
				-- 		pycodestyle = { enabled = false },
				-- 		-- type checker
				-- 		pylsp_mypy = { enabled = true },
				-- 		-- auto-completion options
				-- 		jedi_completion = { fuzzy = true },
				-- 		-- import sorting
				-- 		pyls_isort = { enabled = true },
				-- 	},
				-- 	},
				-- },
				-- flags = {
				-- 	debounce_text_changes = 200,
				-- },
				capabilities = capabilities,
				}
			)

			--Rust
			--require("lspconfig")["rust_analyzer"].setup({
			--	on_attach = on_attach,
			--	capabilities = capabilities,

			--})

			-- C++
			require("lspconfig")["clangd"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = {"h", "c", "cpp", "cc", "obc", "objcpp", "hpp"},
				-- flags = lsp_flags,
				cmd = {
					"clangd",
					"--background-index",
					"--header-insertion=never",
					"--log=verbose",
					"--pretty",
				},
				single_file_support = true,
				-- root_dir = lspconfig.util.root_pattern(
				-- 	'.clangd',
				-- 	'.clang-tidy',
				-- 	'.clang-format',
				-- 	'compile_flags.txt',
				-- 	'.git'
				-- )
			})

		end,
	},
}
