return {
	"Exafunction/codeium.vim",
	key = {
		{ "<M-n>", "<Cmd>call codeium#CycleCompletions(1)<CR>", desc = "Next Suggestion" },
		{ "<M-p>", "<Cmd>call codeium#CycleCompletions(-1)<CR>", desc = "Next Suggestion" },
		--{ "<Tab>", "<Cmd>call codeium#Accept()<CR>", desc = "Next Suggestion" },
	},
	
  -- stylua: ignore
	config = function ()
		 vim.g.codeium_disable_bindings = 1
    		-- Change '<C-g>' here to any keycode you like.
	    vim.keymap.set('i', '<M-c>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
	    vim.keymap.set('i', '<M-->', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
	    vim.keymap.set('i', '<M-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
	    vim.keymap.set('i', '<M-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
	  end
,
}
