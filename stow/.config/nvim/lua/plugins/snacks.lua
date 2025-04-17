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
        Snacks.explorer.open()
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
