return {
	"mbbill/undotree",
	keys = {
		{ "<leader>l", desc = "Undotree" },
		{ "<leader>lh", desc = "Toggle Undotree" },
	},
	config = function()
		-- lh = *L*ocal *H*istory
		vim.api.nvim_set_keymap("n", "<leader>lh", ":UndotreeToggle<CR>", { noremap = true, silent = true })
	end,
}
