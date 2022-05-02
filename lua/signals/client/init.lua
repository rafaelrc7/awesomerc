local awful = require "awful"
require "awful.autofocus"
local wibox = require "wibox"

client.connect_signal("mouse::enter", function(c)
	c:activate { context = "mouse_enter", raise = false }
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	local buttons = {
		awful.button {
			modifiers = { },
			button = 1,
			on_press = function()
				c:activate { context = "titlebar", action = "mouse_move" }
			end
		},
		awful.button {
			modifiers = { },
			button = 3,
			on_press = function()
				c:activate { context = "titlebar", action = "mouse_resize" }
			end
		},
	}

	awful.titlebar(c).widget = {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.minimizebutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	}
end)

-- Keep floating clients on top and give them titlebars
client.connect_signal("property::floating", function(c)
	if c.fullscreen then return end;
	c.ontop = c.floating
	if c.floating then
		awful.titlebar.show(c)
	else
		awful.titlebar.hide(c)
	end
end)

client.connect_signal("property::maximized", function(c)
	if c.maximized then
		--awful.titlebar.hide(c)
	elseif c.floating then
		--awful.titlebar.show(c)
	end
end)

