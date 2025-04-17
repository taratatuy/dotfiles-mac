local M = {}

M.switch_ts_html = function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:match("%.component%.ts$") then
    local html_path = filepath:gsub("%.component%.ts$", ".component.html")
    vim.cmd("edit " .. html_path)
  elseif filepath:match("%.component%.html$") then
    local ts_path = filepath:gsub("%.component%.html$", ".component.ts")
    vim.cmd("edit " .. ts_path)
  else
    print("Not an Angular component .ts or .html file.")
  end
end

return M
