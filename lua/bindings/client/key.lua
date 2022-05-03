local awful = require "awful"

local mod = require "bindings.mod"

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings {
		awful.key {
			modifiers	= { mod.super },
			key			= "f",
			description	= "toggle fullscreen",
			group		= "client",
			on_press	= function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end,
		},
		awful.key {
			modifiers	= { mod.super, mod.shift },
			key			= "c",
			description	= "close",
			group		= "client",
			on_press	= function(c) c:kill() end,
		},
		awful.key {
			modifiers	= { mod.super, mod.ctrl },
			key			= "space",
			description	= "toggle floating",
			group		= "client",
			on_press	= awful.client.floating.toggle,
		},
		awful.key {
			modifiers	= { mod.super },
			key			= "Return",
			description	= "move to master",
			group		= "client",
			on_press	= function(c) c:swap(awful.client.getmaster()) end,
		},
		awful.key {
			modifiers	= { mod.super },
			key			= "o",
			description	= "move to screen",
			group		= "client",
			on_press	= function(c) c:move_to_screen() end,
		},
		awful.key {
			modifiers	= { mod.super },
			key			= "t",
			description	= "toggle keep on top",
			group		= "client",
			on_press	= function(c) c.ontop = not c.ontop end,
		},
		awful.key {
			modifiers	= { mod.super },
			key			= "n",
			description	= "minimise",
			group		= "client",
			on_press	= function(c) c.minimized = true end,
		},
		awful.key {
			modifiers	= { mod.super },
			key			= "m",
			description	= "(un)maximise",
			group		= "client",
			on_press	= function(c)
				c.maximized = not c.maximized
				c:raise()
			end,
		},
		awful.key {
			modifiers	= { mod.super, mod.ctrl },
			key			= "m",
			description	= "(un)maximise vertically",
			group		= "client",
			on_press	= function(c)
				c.maximized_vertical = not c.maximized_vertical
				c:raise()
			end,
		},
		awful.key {
			modifiers	= { mod.super, mod.shift },
			key			= "m",
			description	= "(un)maximise horizontally",
			group		= "client",
			on_press	= function(c)
				c.maximized_horizontal = not c.maximized_horizontal
				c:raise()
			end,
		},
	}
end)

