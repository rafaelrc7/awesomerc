local _M = {}

local awful = require "awful"
local hotkeys_popup = require "awful.hotkeys_popup"
local beautiful = require "beautiful"
local wibox = require "wibox"

local freedesktop = require "freedesktop"
local lain = require "lain"
local markup = lain.util.markup

local apps = require "config.apps"
local mod = require "bindings.mod"

_M.awesomemenu = {
	{ "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{ "manual", apps.manual_cmd },
	{ "edit config", apps.editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit },
}

_M.mainmenu = freedesktop.menu.build {
	before = {
		{ "Awesome", _M.awesomemenu, beautiful.awesome_icon },
	},
	after = {
		{ "Terminal", apps.terminal },
	},
}

_M.launcher = awful.widget.launcher {
	image = beautiful.awesome_icon,
	menu = _M.mainmenu,
}

_M.keyboardlayout = awful.widget.keyboardlayout()

_M.textclock = awful.widget.watch(
	[[date +"%a %d %b %T"]], 1,
	function(widget, stdout)
		widget:set_markup(" " .. markup.font(beautiful.font, stdout))
	end
)

_M.bat = lain.widget.bat {
	settings = function()
		if bat_now.status and bat_now.status ~= "N/A" then
			widget:set_markup(markup.font(beautiful.font, " " .. bat_now.perc .. "% "))
		else
			widget:set_markup(markup.font(beautiful.font, " AC "))
		end
	end
}

_M.cal = lain.widget.cal { attach_to = {_M.textclock} }
_M.cpu = lain.widget.cpu {
	settings = function()
		widget:set_markup(markup.font(beautiful.font, " " .. cpu_now.usage .. "% "))
	end
}

_M.mem = lain.widget.mem {
	settings = function()
		widget:set_markup(markup.font(beautiful.font, " " .. mem_now.used .. "MB "))
	end
}

_M.temp = lain.widget.temp {
	settings = function()
		widget:set_markup(markup.font(beautiful.font, " " .. coretemp_now .. "°C "))
	end
}

_M.create_promptbox = function() return awful.widget.prompt() end

_M.create_layoutbox = function(s)
	return awful.widget.layoutbox {
		screen = s,
		buttons = {
			awful.button {
				modifiers = {},
				button = 1,
				on_press = function() awful.layout.inc(1) end,
			},
			awful.button {
				modifiers = {},
				button = 3,
				on_press = function() awful.layout.inc(-1) end,
			},
			awful.button {
				modifiers = {},
				button = 4,
				on_press = function() awful.layout.inc(-1) end,
			},
			awful.button {
				modifiers = {},
				button = 5,
				on_press = function() awful.layout.inc(1) end,
			},
		},
	}
end

_M.create_taglist = function(s)
	return awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button {
				modifiers = {},
				button = 1,
				on_press = function(t) t:view_only() end,
			},
			awful.button {
				modifiers = {mod.super},
				button = 1,
				on_press = function(t)
					if client.focus then
						client.focus:move_to_tag(t)
					end
				end,
			},
			awful.button {
				modifiers = {},
				button = 3,
				on_press = awful.tag.viewtoggle,
			},
			awful.button {
				modifiers = {mod.super},
				button = 3,
				on_press = function(t)
					if client.focus then
						client.focus:toggle_tag(t)
					end
				end,
			},
			awful.button {
				modifiers = {},
				button = 4,
				on_press = function(t) awful.tag.viewprev(t.screen) end,
			},
			awful.button {
				modifiers = {},
				button = 5,
				on_press = function(t) awful.tag.viewnext(t.screen) end,
			},
		},
	}
end

_M.create_tasklist = function(s)
	return awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button {
				modifiers = {},
				button = 1,
				on_press = function(c)
					c:activate {context = "tasklist", action = "toggle_minimization"}
				end,
			},
			awful.button {
				modifiers = {},
				button = 3,
				on_press = function()
					awful.menu.client_list {beautiful = {width = 250}}
				end,
			},
			awful.button {
				modifiers = {},
				button = 4,
				on_press = function() awful.client.focus.byidx(-1) end
			},
			awful.button {
				modifiers = {},
				button = 5,
				on_press = function() awful.client.focus.byidx(1) end
			},
		},
	}
end

_M.create_wibox = function(s)
	return awful.wibar {
		screen = s,
		position = "top",
		widget = {
			layout = wibox.layout.align.horizontal,
			-- left widgets
			{
				layout = wibox.layout.fixed.horizontal,
				_M.launcher,
				s.taglist,
				s.promptbox,
			},
			-- middles widgets
			s.tasklist,
			-- right widgets
			{
				layout = wibox.layout.fixed.horizontal,
				_M.keyboardlayout,
				wibox.widget.systray(),
				_M.temp,
				_M.cpu,
				_M.mem,
				_M.bat,
				_M.textclock,
				s.layoutbox,
			},
		}
	}
end

return _M

