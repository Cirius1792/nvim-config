return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		opts = {
			-- flutter_path = "/home/clt/develop/bin/",
			debugger = { -- integrate with nvim dap + install dart code debugger
				enabled = false,
				-- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
				-- see |:help dap.set_exception_breakpoints()| for more info
				exception_breakpoints = {},
				-- Whether to call toString() on objects in debug views like hovers and the
				-- variables list.
				-- Invoking toString() has a performance cost and may introduce side-effects,
				-- although users may expected this functionality. null is treated like false.
				evaluate_to_string_in_debug_views = true,
				-- You can use the `debugger.register_configurations` to register custom runner configuration (for example for different targets or flavor). Plugin automatically registers the default configuration, but you can override it or add new ones.
				register_configurations = function(paths)
					require("dap").configurations.dart = {
						-- your custom configuration
					}
				end,
			},
		},
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				line = "<C-c>",
			},
		},
		lazy = false,
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					vim.list_extend(
						opts.ensure_installed,
						{ "java-test", "java-debug-adapter", "gofumpt", "goimports", "debugpy" }
					)
				end,
			},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
      -- stylua: ignore
      keys = {
        { "<leader>dpt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dpc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
		config = function()
			local mason_install_root = require("mason.settings").current.install_root_dir
			local pythonPath
			if vim.fn.has("win32") == 1 then
				-- Set the path for Windows
				pythonPath = "/venv/Scripts/python"
			else
				-- Set the path for Linux or macOS
				pythonPath = "/venv/bin/python"
			end
			require("dap-python").setup(mason_install_root .. "/packages/debugpy" .. pythonPath)
		end,
	},
	{
		"leoluz/nvim-dap-go",
		keys = {
			{
				"<leader>tdg",
				function()
					require("dap-go").debug_test()
				end,
				desc = "Debug Test(Go)",
				ft = "go",
			},
		},
		ft = "go",
		config = true,
	},
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
        --stylua: ignore
		keys = {
            {"<leader>od", function() vim.diagnostic.open_float() end, desc ="Open diagnostic in floating windows"},
        },
		ft = { "go", "gomod", "gowork", "gosum", "lua", "markdown", "python" },
		config = function()
			require("fidget").setup({})
			local servers = { "lua_ls", "ty", "marksman", "gopls" }
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})
			vim.lsp.config("ty", {
				capabilities = capabilities,
			})
			vim.lsp.config("marksman", {
				capabilities = capabilities,
			})
			vim.lsp.config("gopls", vim.tbl_deep_extend("force", require("plugins.lsps.go"), {
				capabilities = capabilities,
			}))

			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_enable = true,
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
		end,
	},
}
