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
		opts = {
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			defaults = {
				["<leader>t"] = { name = "+test" },
			},
		},
	},
}
