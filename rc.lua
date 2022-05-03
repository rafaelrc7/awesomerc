-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message
	}
end)
-- }}}

local theme_path = string.format("%s/themes/", gears.filesystem.get_configuration_dir())
beautiful.init(theme_path .. "default/theme.lua")

package.path = package.path .. ";"
	.. gears.filesystem.get_configuration_dir() .. "lua/?.lua;"
	.. gears.filesystem.get_configuration_dir() .. "lua/?/init.lua;"

require "bindings"
require "rules"
require "signals"

local autorun_path = string.format("%s/awesome/autorun.sh", gears.filesystem.get_configuration_dir())
awful.spawn.with_shell(string.format([[[-e %s] && %s]], autorun_path, autorun_path))

