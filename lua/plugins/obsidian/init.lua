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
        "telescope.nvim",
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
		daily_notes = {
			folder = "DailyNotes",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = nil,
		},
		new_notes_location = "current_dir",
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like 'my-new-note-1657296016', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return suffix .. "-" .. tostring(os.time())
		end,
	},
}
