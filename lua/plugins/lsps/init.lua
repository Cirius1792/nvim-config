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
			local lspconfig = require("lspconfig")
			local servers = { "lua_ls", "pyright", "marksman" }
			local noop = function() end

			require("mason-lspconfig").setup_handlers({
				["jdtls"] = noop,
			})
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			lspconfig.pyright.setup({})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local wk = require("which-key")
					wk.register({
						["gD"] = { vim.lsp.buf.declaration, "go to declaration" },
						["gd"] = { vim.lsp.buf.definition, "go to definition" },
						["gi"] = { vim.lsp.buf.implementation, "go to implementation" },
						["K"] = { vim.lsp.buf.hover, "show doc" },
						["<C-Space>"] = { vim.lsp.buf.signature_help, "Show signature" },
						["<space>wa"] = { vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
						["<space>wr"] = { vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder" },
						["<space>wl"] = {
							function()
								print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
							end,
							"List Workspace Folders",
						},
						["<space>D"] = { vim.lsp.buf.type_definition, "Type Definition" },
						["<space>rn"] = { vim.lsp.buf.rename, "Rename" },
						["gr"] = { vim.lsp.buf.references, "References" },
					}, { mode = "n", buffer = args.buf })
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
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
