return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { 
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim"
		},
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
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			
			-- Configure telescope and ui-select extension
			telescope.setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({})
					}
				}
			})
			
			-- Load the ui-select extension
			telescope.load_extension("ui-select")
			
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
			vim.keymap.set("n", "<leader>ft", builtin.live_grep, {})
		end,
	},
}
