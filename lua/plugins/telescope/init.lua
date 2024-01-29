return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>f", desc = "Find" },
		{ "<leader>ff", desc = "Find Files" },
		{ "<leader>fg", desc = "Find Text" },
		{ "<leader>fG", desc = "Find Git Files" },
		{ "<leader>fo", "<cmd>ObsidianSearch<cr>", desc = "Find Obsidian Note" },
	},
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fG", builtin.git_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	end,
}
