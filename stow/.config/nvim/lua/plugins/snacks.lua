---@class snacks.picker.explorer.Config: snacks.picker.files.Config|{}
---@field follow_file? boolean follow the file from the current buffer
---@field tree? boolean show the file tree (default: true)
---@field git_status? boolean show git status (default: true)
---@field git_status_open? boolean show recursive git status for open directories
---@field git_untracked? boolean needed to show untracked git status
---@field diagnostics? boolean show diagnostics
---@field diagnostics_open? boolean show recursive diagnostics for open directories
---@field watch? boolean watch for file changes
---@field exclude? string[] exclude glob patterns
---@field include? string[] include glob patterns. These take precedence over `exclude`, `ignored` and `hidden`
local explorerConfig = {
  hidden = true,
  ignored = true,
}

return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = {},
    lazygit = {},
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 100 },
        easing = "linear",
      },
      -- faster animation when repeating scroll after delay
      animate_repeat = {
        delay = 100, -- delay in ms before using the repeat animation
        duration = { step = 5, total = 50 },
        easing = "linear",
      },
      -- what buffers to animate
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
      end,
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer.open(explorerConfig)
      end,
      desc = "File [E]xplorer",
    },
    {
      "<leader>g",
      function()
        Snacks.lazygit.open()
      end,
      desc = "Lazy [G]it",
    },
  },
}
