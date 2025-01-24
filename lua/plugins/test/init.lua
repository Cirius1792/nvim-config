return {
	{
		"rcasia/neotest-java",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-jdtls",
			"mfussenegger/nvim-dap", -- for the debugger
			"rcarriga/nvim-dap-ui", -- recommended
			"theHamsta/nvim-dap-virtual-text", -- recommended
		},
	},
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
			"nvim-neotest/neotest-go",
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
			-- Function to get appropriate adapters based on filetype
			local function get_adapters()
				local ft = vim.bo.filetype
				local adapters = {}

				if ft == "python" then
					table.insert(adapters, require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest",
						python = pythonPath,
					}))
				elseif ft == "go" then
					table.insert(adapters, require("neotest-go"))
				elseif ft == "java" then
					table.insert(adapters, require("neotest-java"))
				end

				return adapters
			end

			require("neotest").setup({
				adapters = get_adapters(),
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
