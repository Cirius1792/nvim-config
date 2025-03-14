vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.api.nvim_command("set ff=unix")
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

if vim.fn.has("persistent_undo") then
	local target_path = vim.fn.expand("~/.undodir")

	-- create the directory and any parent directories
	-- if the location does not exist.
	if vim.fn.isdirectory(target_path) == 0 then
		vim.fn.mkdir(target_path, "p", 0700)
	end

	vim.o.undodir = target_path
	vim.o.undofile = true
end

vim.opt.scrolloff = 8

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-f>", "<C-u>zz")
vim.keymap.set("x", "<C-p>", '"_dP')

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })

vim.lsp.handlers["textDocument/hover"] =
	vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", width = 50, height = 20 })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Use Telescope for code actions
local telescope_loaded, _ = pcall(require, "telescope")
if telescope_loaded then
	local action_state = require("telescope.actions.state")
	local actions = require("telescope.actions")
	local original_code_action_handler = vim.lsp.handlers["textDocument/codeAction"]
	
	vim.lsp.handlers["textDocument/codeAction"] = function(_, result, ctx, config)
		if not result or vim.tbl_isempty(result) then
			vim.notify("No code actions available", vim.log.levels.INFO)
			return
		end
		
		-- Use the original handler if telescope isn't ready yet
		if not telescope_loaded then
			return original_code_action_handler(_, result, ctx, config)
		end
		
		local actions_callback = function(action)
			if action then
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, "UTF-8")
				end
				if action.command then
					local command = type(action.command) == "table" and action.command or action
					local fn = vim.lsp.commands[command.command]
					if fn then
						fn(command)
					else
						vim.lsp.buf.execute_command(command)
					end
				end
			end
		end
		
		require("telescope.pickers").new({}, {
			prompt_title = "Code Actions",
			finder = require("telescope.finders").new_table({
				results = result,
				entry_maker = function(action)
					return {
						value = action,
						display = action.title,
						ordinal = action.title,
					}
				end,
			}),
			sorter = require("telescope.config").values.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					actions_callback(selection.value)
				end)
				return true
			end,
		}):find()
	end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.conceallevel = 2
vim.opt.rtp:prepend(lazypath)
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
require("lazy").setup("plugins")
