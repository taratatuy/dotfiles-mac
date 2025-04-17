return {
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    keywords = {
      TODO = { icon = " ", color = "info", alt = { "TODO ALTI0821" } },
    },
    highlight = {
      pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
    },
    pattern = [[\b(KEYWORDS)\b]],
  },
}
