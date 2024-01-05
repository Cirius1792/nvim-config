return {
	'preservim/nerdtree',
	config = function()
		vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
		vim.api.nvim_set_keymap('n', '<leader>nf', ':NERDTreeFind<CR> ', { noremap = true, silent = true })
		vim.g.NERDTreeWinSize = 45
	end
}
