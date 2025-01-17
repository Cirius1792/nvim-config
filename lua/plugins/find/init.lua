return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>f", desc = "+Find" },
			{ "<leader>ff", desc = "Find Files" },
			{ "<leader>ft", desc = "Find Text" },
			{ "<leader>fg", desc = "Find Git Files" },
			{
				"<leader>fr",
				function()
					require("telescope.builtin").lsp_references()
				end,
				desc = "Find references",
			},
			{ "<leader>fo", "<cmd>ObsidianSearch<cr>", desc = "Find Obsidian Note" },
		},
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
			vim.keymap.set("n", "<leader>ft", builtin.live_grep, {})
		end,
	},
}
