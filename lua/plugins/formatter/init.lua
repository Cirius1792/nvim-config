return {
	"mhartington/formatter.nvim",
	config = function()
		require("formatter").setup({
			filetype = {
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				java = {
					require("formatter.filetypes.java").clang_format,
				},
				python = {
					require("formatter.filetypes.python").autopep8,
				},
			},
		})
		local augroup = vim.api.nvim_create_augroup
		local autocmd = vim.api.nvim_create_autocmd
		augroup("__formatter__", { clear = true })
		autocmd("BufWritePost", {
			group = "__formatter__",
			command = ":FormatWrite",
		})

		vim.api.nvim_set_keymap("n", "<C-f>", ":Format<CR>", { noremap = true, silent = true })
	end,
}
