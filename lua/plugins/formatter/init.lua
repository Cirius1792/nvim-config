return {
	"mhartington/formatter.nvim",
	keys = { { "<C-f>", ":FormatWrite<CR>", desc = "Format" } },
	config = function()
		require("formatter").setup({
			filetype = {
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				java = {
					require("formatter.filetypes.java").google_java_format,
					-- require("formatter.filetypes.java").clangformat,
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
	end,
}
