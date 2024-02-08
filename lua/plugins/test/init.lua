return {
	{
		"nvim-neotest/neotest",
		event = "LspAttach",
		ft = "python",
		dependencies = {
			"folke/trouble.nvim",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
		config = function()
			local pythonPath
			if vim.fn.has("win32") == 1 then
				-- Set the path for Windows
				pythonPath = ".venv/Scripts/python"
			else
				-- Set the path for Linux or macOS
				pythonPath = ".venv/bin/python"
			end
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest",
						--python = ".venv/Scripts/python",
						python = pythonPath,
					}),
				},
				status = { virtual_text = true },
				output = { open_on_run = true },
				--	quickfix = {
				--		open = function()
				--			require("trouble").open({ mode = "quickfix", focus = false })
				--		end,
				--	},
			})
		end,
  -- stylua: ignore
          keys = {
            { "<leader>t", desc="Test"},
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run Current File" },
            { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
            { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
          },
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
  -- stylua: ignore
           keys = {
             { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
           },
	},
}
