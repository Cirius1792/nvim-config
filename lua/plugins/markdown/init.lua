return {
  -- Browser-based markdown preview (kept for rendering/exporting in a real browser)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable "npx" then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable "npx" then vim.g.mkdp_filetypes = { "markdown" } end
    end,
  },

  -- In-editor markdown/HTML/LaTeX/Typst/YAML previewer
  {
    "OXY2DEV/markview.nvim",
    -- Do NOT lazy load: the plugin already lazy-loads itself internally.
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- Needed for `preview.icon_provider = "devicons"` (already installed via lualine)
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local presets = require("markview.presets")

      require("markview").setup({
        preview = {
          icon_provider = "devicons",
        },
        markdown = {
          headings = presets.headings.glow,
          tables = presets.tables.rounded,
        },
        markdown_inline = {
          enable = true,
        },
      })
    end,
  },
}
