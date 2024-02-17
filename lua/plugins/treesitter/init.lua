return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			highlight = { enable = true },
			ensure_installed = {
				"python",
				"java",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"go",
				"gomod",
				"gowork",
				"gosum",
			},
			auto_install = true,
		})
	end,
}
