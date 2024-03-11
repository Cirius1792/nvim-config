return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
  -- stylua: ignore
	keys = {
		{ "<leader>e", desc = "Refactoring" },
		{ "<leader>ev", desc = "Extract Variable" },
	},
	ft = { "python", "go" }, -- Load the plugin only on Python files
	config = function()
		require("refactoring").setup()
		vim.keymap.set("x", "<leader>ev", ":Refactor extract_var ")
	end,
}
