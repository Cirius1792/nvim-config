return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			integrations = {
				treesitter = true,
				notify = false,
			},
		},
		config = function()
			vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
}
