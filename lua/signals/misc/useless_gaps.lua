local awful = require "awful"
local beautiful = require "beautiful"

-- No Useless gaps on the corners
-- Thanks to u/TehGritz
local set_outside_padding = function(s, amount)
    if beautiful.fixed_outside_gap then
        s.padding = {
            left = amount,
            right = amount,
            top = amount,
            bottom = amount
        }
    end
end

local update_spacing_by_screen = function(s)
    for _,t in pairs(s.selected_tags) do --iterate through all selected tags first
        if t.gap == 0 or t.layout.name == "max" then -- what happens if tag gaps are 0 or a layout we have selected has maximized gaps
            set_outside_padding(s, 0)
            return false
        end
    end
    if #s.tiled_clients == 1 or #s.clients == 0 then  -- what happens if only one tiled client is visible or if NO clients are visible
        set_outside_padding(s, 0)
        return false
    else --we must iterate through clients on screen to determine what to do
        for _,c in pairs(s.clients) do
            if c.maximized or (c.ontop and not c.floating) or c.maximized_vertical or c.maximized_horizontal or c.fullscreen then --when outside padding should be reset
                set_outside_padding(s, 0)
                return false
            end
        end
        -- If we reach this point, that means none of the visible clients were in a state that should prevent the negative padding from being set
        if s.selected_tag then
			set_outside_padding(s,
				(-(s.selected_tag.gap*2)+beautiful.fixed_outside_gap_amount) or 0)
		end
        return true
    end
end

tag.connect_signal("property::useless_gap", function(t)
    if t.gap == 0 or beautiful.fixed_outside_gap then -- note that it affects the smoothness of the gap scrolling with mousewheel if we enable fixed_outside_gap, since it has to do the function above for every click of the scroll wheel
        update_spacing_by_screen(t.screen)
    end
end)

-- When a tag is active and can be used
tag.connect_signal("property::activated", function(t)
    update_spacing_by_screen(t.screen)
end)

-- When a client is sent away from a tag
tag.connect_signal("untagged", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a tag is selected
tag.connect_signal("property::selected", function(t)
    update_spacing_by_screen(t.screen)
end)

-- When a new client appears
client.connect_signal( "manage", function(c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    update_spacing_by_screen(c.screen)
end)

-- When a client is (un)maximized
client.connect_signal("property::maximized", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client is (un)fullscreened
client.connect_signal("property::fullscreen", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client is (un)minimized
client.connect_signal("property::minimized", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client is (un)hidden
client.connect_signal("property:hidden", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client's (un)floated
client.connect_signal("property::floating", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client is (un)maximized vertically
client.connect_signal("property::maximized_vertical", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client is (un)maximized horizontally
client.connect_signal("property::maximized_horizontal", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client is (un)sticked
client.connect_signal("property::sticky", function(c)
    update_spacing_by_screen(c.screen)
end)

-- When a client requests a new screen, and update the old_screen while we're at it
client.connect_signal("property::screen", function(c, old_screen)
    update_spacing_by_screen(c.screen)
    if old_screen then update_spacing_by_screen(old_screen) end
end)

