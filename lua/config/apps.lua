_M = {
	terminal = os.getenv("TERMINAL") or "kitty",
	editor = os.getenv("EDITOR") or "nvim",
}

_M.editor_cmd = _M.terminal .. " -- " .. _M.editor
_M.manual_cmd = _M.terminal .. " -- man awesome"

return _M

