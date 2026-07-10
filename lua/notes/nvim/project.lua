local M = {}

local function git_root(cwd)
  local out = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })
  if vim.v.shell_error ~= 0 or #out == 0 then
    return nil
  end
  return out[1]
end

function M.notes_root()
  return vim.fn.expand("~/notes")
end

function M.resolve(cwd)
  cwd = cwd or vim.fn.getcwd()
  local root = git_root(cwd)
  if not root then
    root = cwd
  end

  local name = vim.fn.fnamemodify(root, ":t")
  local parent_name = vim.fn.fnamemodify(root, ":h:t")

  local notes_root = M.notes_root()
  local candidate = notes_root .. "/" .. name

  local marker = candidate .. "/.root"
  if vim.fn.isdirectory(candidate) == 1 and vim.fn.filereadable(marker) == 1 then
    local existing_root = vim.fn.readfile(marker)[1]
    if existing_root ~= root then
      name = name .. "-" .. parent_name
      candidate = notes_root .. "/" .. name
    end
  end

  return { root = root, name = name, dir = candidate }
end

function M.ensure_dir(project)
  vim.fn.mkdir(project.dir, "p")
  local marker = project.dir .. "/.root"
  if vim.fn.filereadable(marker) == 0 then
    vim.fn.writefile({ project.root }, marker)
  end
end

return M
