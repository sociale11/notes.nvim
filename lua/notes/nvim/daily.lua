local project = require("notes.nvim.project")

local M = {}

local function today_filename()
  return os.date("%Y-%m-%d") .. ".md"
end

function M.today_path(cwd)
  local proj = project.resolve(cwd)
  project.ensure_dir(proj)
  return proj.dir .. "/" .. today_filename(), proj
end

function M.open_today()
  local path, proj = M.today_path()
  local is_new = vim.fn.filereadable(path) == 0

  vim.cmd("edit " .. vim.fn.fnameescape(path))

  if is_new then
    local header = "# " .. proj.name .. " — " .. os.date("%Y-%m-%d") .. "\n\n"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(header, "\n"))
    vim.cmd("normal! G")
  end
end

return M
