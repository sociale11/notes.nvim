local project = require("notes.nvim.project")
local daily = require("notes.nvim.daily")

local M = {}

function M.toggle()
	local proj = project.resolve()
	project.ensure_dir(proj)

	local ok, _ = pcall(require, "neo-tree")
	if not ok then
		vim.notify("dailynote: neo-tree.nvim not found", vim.log.levels.ERROR)
		return
	end

	daily.open_today()

	vim.cmd(
		string.format("Neotree source=filesystem position=right dir=%s reveal_force_cwd", vim.fn.fnameescape(proj.dir))
	)
end

function M.setup(opts)
	opts = opts or {}
	vim.keymap.set("n", "<leader>nn", M.toggle, { desc = "Toggle daily note panel" })
	vim.api.nvim_create_user_command("Notes", M.toggle, {})
end

return M
