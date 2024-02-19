return {
	"mhartington/formatter.nvim",
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					vim.list_extend(opts.ensure_installed, { "google-java-format", "stylua", "autopep8", "black", })
				end,
			},
		},
	keys = { { "<C-f>", ":FormatWrite<CR>", desc = "Format" } },
	config = function()
		require("formatter").setup({
			filetype = {
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				java = {
					require("formatter.filetypes.java").google_java_format,
				},
				python = {
					require("formatter.filetypes.python").autopep8,
				},

				go = {
					require("formatter.filetypes.go").gofmt,
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
