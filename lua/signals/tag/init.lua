local awful = require "awful"

local vars = require "config.vars"

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts(vars.layouts)
end)

tag.connect_signal("property::layout", function(t)
	for _, c in pairs(t:clients()) do
		if t.layout == awful.layout.suit.floating and not (c.maximized or c.fullscreen) then
			awful.titlebar.show(c)
		else
			awful.titlebar.hide(c)
		end
	end
end)

