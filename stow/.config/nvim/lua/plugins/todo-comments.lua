return {
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    keywords = {
      TODO = { icon = " ", color = "error", alt = { "TODO alti0821" } },
    },
    highlight = {
      pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
    },
    pattern = [[\b(KEYWORDS)\b]],
  },
}
