local ok, sys_apps = pcall(require, "sys_apps")

_M = {
	terminal = os.getenv("TERMINAL") or "kitty",
	editor = os.getenv("EDITOR") or "nvim",
	browser = os.getenv("BROWSER") or "librewolf",
	explorer = os.getenv("EXPLORER") or "pcmanfm",
}

_M.editor_cmd = _M.terminal .. " -- " .. _M.editor
_M.manual_cmd = _M.terminal .. " -- man awesome"

if ok then
	_M.screenshot = sys_apps.screenshot
	_M.lockscreen = sys_apps.lockscreen
	_M.bright = sys_apps.bright
	_M.volume = sys_apps.volume
else
	_M.screenshot = "flameshot gui"
	_M.lockscreen = "xlock -mode blank"
	_M.bright = {
	  inc = "xbacklight -inc 10",
	  dec = "xbacklight -dec 10",
	}
	_M.volume = {
	  inc = "pamixer -i 5",
	  dec = "pamixer -d 5",
	  mute = "pamixer -t",
	}
end

return _M

