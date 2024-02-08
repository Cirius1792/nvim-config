return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"j-hui/fidget.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"MunifTanjim/nui.nvim",
			"mfussenegger/nvim-dap",
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"hrsh7th/nvim-cmp", -- Autocompletion plugin
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
			"L3MON4D3/LuaSnip", -- Snippets plugin
		},
		config = function()
			require("fidget").setup({})
			require("mason").setup()
			local servers = { "lua_ls", "pyright", "jdtls", "marksman" }
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({})
			lspconfig.jdtls.setup({
				root_dir = function()
					print("Sto cercando la root")
					return vim.fs.dirname(
						vim.fs.find({ ".gradlew", ".gitignore", "mvnw", "build.grade.kts" }, { upward = true })[1]
					) .. "\\"
				end,
				on_attach = function(client, bufnr)
					print("Sono in on attach")
					-- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L88-L94
					local opts = { silent = true, buffer = bufnr }
					vim.keymap.set(
						"n",
						"<leader>lo",
						jdtls.organize_imports,
						{ desc = "Organize imports", buffer = bufnr }
					)
					-- Should 'd' be reserved for debug?
					vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)
					vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
					vim.keymap.set(
						"n",
						"<leader>ev",
						jdtls.extract_variable_all,
						{ desc = "Extract variable", buffer = bufnr }
					)
					vim.keymap.set(
						"v",
						"<leader>em",
						[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
						{ desc = "Extract method", buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"<leader>ec",
						jdtls.extract_constant,
						{ desc = "Extract constant", buffer = bufnr }
					)
				end,
			})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-Space>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<space>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					--vim.keymap.set("n", "<space>f", function()
					--	vim.lsp.buf.format({ async = true })
					--end, opts)
				end,
			})

			-- Auto Completion with CMP
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					-- on_attach = my_custom_on_attach,
					capabilities = capabilities,
				})
			end
			local luasnip = require("luasnip")
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.scroll_docs(-4), -- Up
					["<C-j>"] = cmp.mapping.scroll_docs(4), -- Down
					-- C-b (back) C-f (forward) for snippet placeholder navigation.
					--["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			})
		end,
	},
	{ "folke/neodev.nvim", opts = {} },
}
