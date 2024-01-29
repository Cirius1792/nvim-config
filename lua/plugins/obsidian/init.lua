return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},
	keys = {
		{ "<leader>o", desc = "Obsidian" },
		{ "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
		{ "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today Note" },
		{ "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday Note" },
		{ "<leader>ott", "<cmd>ObsidianTomorrow<cr>", desc = "Yesterday Note" },
		{ "<leader>ogf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link" },
		{ "<leader>orn", "<cmd>ObsidianRename<cr>", desc = "Rename Note" },
	},
	opts = {
		workspaces = require("plugins.obsidian.workspaces"),
	},
}
