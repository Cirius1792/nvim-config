return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"nvim-java/nvim-java",
		"nvim-java/lua-async-await",
		"nvim-java/nvim-java-core",
		"nvim-java/nvim-java-test",
		"nvim-java/nvim-java-dap",
		"MunifTanjim/nui.nvim",
		"j-hui/fidget.nvim",
		{
			"williamboman/mason.nvim",
			opts = {
				registries = {
					"github:nvim-java/mason-registry",
					"github:mason-org/mason-registry",
				},
			},
		},
		"williamboman/mason-lspconfig.nvim",
		"MunifTanjim/nui.nvim",
		{
			"mfussenegger/nvim-dap",
			keys = {
				{
					"<leader>dB",
					function()
						require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
					end,
					desc = "Breakpoint Condition",
				},
				{
					"<leader>db",
					function()
						require("dap").toggle_breakpoint()
					end,
					desc = "Toggle Breakpoint",
				},
				{
					"<leader>dc",
					function()
						require("dap").continue()
					end,
					desc = "Continue",
				},
				{
					"<leader>da",
					function()
						require("dap").continue({ before = get_args })
					end,
					desc = "Run with Args",
				},
				{
					"<leader>dC",
					function()
						require("dap").run_to_cursor()
					end,
					desc = "Run to Cursor",
				},
				{
					"<leader>dg",
					function()
						require("dap").goto_()
					end,
					desc = "Go to line (no execute)",
				},
				{
					"<leader>di",
					function()
						require("dap").step_into()
					end,
					desc = "Step Into",
				},
				{
					"<leader>dn",
					function()
						require("dap").down()
					end,
					desc = "Down",
				},
				{
					"<leader>dl",
					function()
						require("dap").run_last()
					end,
					desc = "Run Last",
				},
				{
					"<leader>do",
					function()
						require("dap").step_out()
					end,
					desc = "Step Out",
				},
				{
					"<leader>dO",
					function()
						require("dap").step_over()
					end,
					desc = "Step Over",
				},
				{
					"<leader>dp",
					function()
						require("dap").pause()
					end,
					desc = "Pause",
				},
				{
					"<leader>dr",
					function()
						require("dap").repl.toggle()
					end,
					desc = "Toggle REPL",
				},
				{
					"<leader>ds",
					function()
						require("dap").session()
					end,
					desc = "Session",
				},
				{
					"<leader>dt",
					function()
						require("dap").terminate()
					end,
					desc = "Terminate",
				},
				{
					"<leader>dw",
					function()
						require("dap.ui.widgets").hover()
					end,
					desc = "Widgets",
				},
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
		{
			"rcarriga/nvim-dap-ui",
		      -- stylua: ignore
		      keys = {
		        { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
		        { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
		      },
			opts = {},
			config = function(_, opts)
				-- setup dap config by VsCode launch.json file
				-- require("dap.ext.vscode").load_launchjs()
				local dap = require("dap")
				local dapui = require("dapui")
				dapui.setup(opts)
				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open({})
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close({})
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close({})
				end
			end,
		},
		"hrsh7th/nvim-cmp", -- Autocompletion plugin
		"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
		"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
		"L3MON4D3/LuaSnip", -- Snippets plugin
		"vim-test/vim-test",
	},

	config = function()
		require("fidget").setup({})
		local servers = { "lua_ls", "pyright", "jdtls", "marksman" }
		require("mason").setup({
			ensure_installed = servers,
			automatic_installation = true,
		})
		require("mason-lspconfig").setup()

		local lspconfig = require("lspconfig")
		require("java").setup()
		lspconfig.pyright.setup({})
		lspconfig.jdtls.setup({})

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
}
