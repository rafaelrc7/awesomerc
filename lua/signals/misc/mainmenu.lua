local awful = require "awful"
local widgets = require "widgets"

-- Hide menu when mouse leaves it (based on lcpz/awesome-copycats)
widgets.mainmenu.wibox:connect_signal("mouse::leave", function()
	local mainmenu = widgets.mainmenu
	if not mainmenu.active_child or (mainmenu.wibox ~= mouse.current_wibox
		and mainmenu.active_child.wibox ~= mouse.current_wibox)
	then mainmenu:hide()
	else
		mainmenu.active_child.wibox:connect_signal("mouse::leave", function()
			if mainmenu.wibox ~= mouse.current_wibox then
				mainmenu:hide()
			end
		end)
	end


end)

