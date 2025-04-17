return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require("mini.statusline")
    -- set use_icons to true if you have a Nerd Font
    statusline.setup({ use_icons = vim.g.have_nerd_font })

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function(args)
      -- Use virtual column number to allow update when past last column
      if statusline.is_truncated(args.trunc_width) then
        return "%l %2v"
      end

      -- Use `virtcol()` to correctly handle multi-byte characters
      return '%l:%L %2v:%-2{virtcol("$") - 1}'
    end

    vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", {})
    vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { link = "DiffText" })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_fileinfo = function(args)
      local filetype = vim.bo.filetype
      if (filetype == "") or vim.bo.buftype ~= "" then
        return ""
      end
      local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")

      local devicons = require("nvim-web-devicons")
      local icon = devicons.get_icon(file_name, file_ext, { default = true })
      if icon ~= "" then
        filetype = string.format("%s %s", icon, filetype)
      end

      if statusline.is_truncated(args.trunc_width) then
        return filetype
      end
      return filetype
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
