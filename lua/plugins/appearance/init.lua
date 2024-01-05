return {
	'catppuccin/nvim', 
	name = 'catppuccin',
	opts = {
	    integrations = {
	        treesitter = true,
	        notify = false
	    }
	},
	config = function()
			vim.cmd('colorscheme catppuccin')
		end 
}
