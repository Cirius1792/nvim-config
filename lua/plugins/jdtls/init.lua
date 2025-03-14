return {
	{
		"mfussenegger/nvim-jdtls",
		dependencies = {
			"folke/neodev.nvim",
			"folke/which-key.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/nvim-cmp", -- Autocompletion plugin
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
			"L3MON4D3/LuaSnip", -- Snippets plugin
			"j-hui/fidget.nvim",
		},
		ft = { "java" },
		config = function()
			require("fidget").setup({})

			require("mason").setup()
			local servers = { "jdtls" }
			local noop = function() end

			require("mason-lspconfig").setup_handlers({
				["jdtls"] = noop,
			})
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})
			local opts = {
				root_dir = function()
					return require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
				end,

				project_name = function(root_dir)
					return root_dir and vim.fs.basename(root_dir)
				end,

				jdtls_config_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
				end,
				jdtls_workspace_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
				end,

				-- How to run jdtls. This can be overridden to a full java command-line
				-- if the Python wrapper script doesn't suffice.
				cmd = {
					vim.fn.exepath("jdtls"),
					"--jvm-arg=" .. string.format(
						"-javaagent:%s",
						vim.fn.expand(vim.env.xdg_data_home .. "/nvim-data/mason/share/jdtls/lombok.jar")
					),
					--  "--jvm-arg=-javaagent:" .. xdg_data .. "/nvim-data/mason/packages/jdtls/lombok.jar",
				},
				full_cmd = function(opts)
					local fname = vim.api.nvim_buf_get_name(0)
					local root_dir = opts.root_dir(fname)
					local project_name = opts.project_name(root_dir)
					local cmd = vim.deepcopy(opts.cmd)
					-- vim.list_extend(cmd, {
					-- 	"--jvm-arg=-javaagent:" .. xdg_data .. "/nvim-data/mason/packages/jdtls/lombok.jar",
					-- })
					if project_name then
						vim.list_extend(cmd, {
							"-configuration",
							opts.jdtls_config_dir(project_name),
							"-data",
							opts.jdtls_workspace_dir(project_name),
						})
					end
					return cmd
				end,

				-- These depend on nvim-dap, but can additionally be disabled by setting false here.
				dap = { hotcodereplace = "auto", config_overrides = {} },
				test = true,
			}

			-- Find the extra bundles that should be passed on the jdtls command-line
			-- if nvim-dap is enabled with java debug/test.
			local mason_registry = require("mason-registry")
			local bundles = {} ---@type string[]
			local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
			local java_dbg_path = java_dbg_pkg:get_install_path()
			local jar_patterns = {
				java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
			}
			-- java-test also depends on java-debug-adapter.
			local java_test_pkg = mason_registry.get_package("java-test")
			local java_test_path = java_test_pkg:get_install_path()
			vim.list_extend(jar_patterns, {
				java_test_path .. "/extension/server/*.jar",
			})
			for _, jar_pattern in ipairs(jar_patterns) do
				for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
					table.insert(bundles, bundle)
				end
			end

			---
			local function attach_jdtls()
				local fname = vim.api.nvim_buf_get_name(0)

				-- Configuration can be augmented and overridden by opts.jdtls
				local config = {
					cmd = opts.full_cmd(opts),
					root_dir = opts.root_dir(fname),
					init_options = {
						bundles = bundles,
					},
					-- enable CMP capabilities
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				}

				-- Existing server will be reused if the root_dir matches.
				require("jdtls").start_or_attach(config)
				-- not need to require("jdtls.setup").add_commands(), start automatically adds commands
			end

			---
			-- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
			-- depending on filetype, so this autocmd doesn't run for the first file.
			-- For that, we call directly below.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "java" },
				callback = attach_jdtls,
			})

			-- Setup keymap and dap after the lsp is fully attached.
			-- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
			-- https://neovim.io/doc/user/lsp.html#LspAttach
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "jdtls" then
						local wk = require("which-key")
						wk.register({
							["<leader>od"] = { vim.diagnostic.open_float, "Open diagnostic in floating windows" },
							["<leader>e"] = { name = "+Refactoring" },
							["<leader>ev"] = { require("jdtls").extract_variable_all, "Extract Variable" },
							["<leader>ec"] = { require("jdtls").extract_constant, "Extract Constant" },
							["g"] = { name = "+Navigation" },
							["gs"] = { require("jdtls").super_implementation, "Goto Super" },
							["gS"] = { require("jdtls.tests").goto_subjects, "Goto Subjects" },
							["gd"] = { vim.lsp.buf.definition, "go to definition" },
							["gi"] = { vim.lsp.buf.implementation, "go to implementation" },
							["<leader>co"] = { require("jdtls").organize_imports, "Organize Imports" },
							["K"] = { vim.lsp.buf.hover, "show doc" },
							["<C-Space>"] = { vim.lsp.buf.signature_help, "Show signature" },
							["<space>w"] = { name = "+Workspace" },
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
						wk.register({
							["<leader>em"] = {
								[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
								"Extract Method",
							},
							["<leader>ev"] = {
								[[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
								"Extract Variable",
							},
							["<leader>ec"] = {
								[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
								"Extract Constant",
							},
						}, { mode = "v", buffer = args.buf })

						-- custom init for Java debugger
						require("jdtls").setup_dap(opts.dap)
						require("jdtls.dap").setup_dap_main_class_configs()

						-- Java Test require Java debugger to work
						-- custom keymaps for Java test runner (not yet compatible with neotest)
						-- wk.register({
						-- 	["<leader>t"] = { name = "+test" },
						-- 	["<leader>tt"] = { require("jdtls.dap").test_class, "Run All Test" },
						-- 	["<leader>tr"] = { require("jdtls.dap").test_nearest_method, "Run Nearest Test" },
						-- 	["<leader>tT"] = { require("jdtls.dap").pick_test, "Run Test" },
						-- }, { mode = "n", buffer = args.buf })

						-- User can set additional keymaps in opts.on_attach
						if opts.on_attach then
							opts.on_attach(args)
						end
					end
				end,
			})
			attach_jdtls()
		end,
	},
}
