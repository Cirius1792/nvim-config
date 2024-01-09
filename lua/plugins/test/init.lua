return {
	"nvim-neotest/neotest",
	event = "LspAttach",
	dependencies = {
		"folke/trouble.nvim",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
		"rcasia/neotest-java",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					dap = { justMyCode = false },
					runner = "pytest",
					python = ".venv/Scripts/python",
				}),
				require("neotest-java")({
					ignore_wrapper = true, -- whether to ignore maven/gradle wrapper
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
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
  },
}
