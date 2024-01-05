return{
	'mbbill/undotree',
	config = function()
		-- lh = *L*ocal *H*istory
		vim.api.nvim_set_keymap('n', '<leader>lh', ':UndotreeToggle<CR>', { noremap = true, silent = true })
	end
}
