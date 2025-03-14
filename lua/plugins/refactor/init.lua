return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
  -- stylua: ignore
	keys = {
		{ "<leader>e", desc = "Refactoring" },
		{ "<leader>ev", function() require('refactoring').refactor('Extract Variable') end, desc = "Extract Variable" },
		{ "<leader>em", function() require('refactoring').refactor('Extract Function') end, desc = "Extract Method" },
		{ "<leader>rr",  function() require("telescope").extensions.refactoring.refactors() end, desc = "Refactoring Menu" },
	},
	ft = { "python", "go" }, -- Load the plugin only on Python files
	config = function()
		require("refactoring").setup()
		require("telescope").load_extension("refactoring")
	end,
}
