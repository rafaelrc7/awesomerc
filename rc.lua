-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.

pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
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

local freedesktop = require("freedesktop")
local lain = require("lain")

local widgets = require("widgets")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function() widgets.mainmenu:toggle() end),
})
-- }}}

require "rules"
require "signals"
local apps = require "config.apps"

-- {{{ Key bindings

local modkey = "Mod4"

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "w", function () widgets.mainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().promptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(apps.terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.screen.focused().promptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- }}}

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
        set_outside_padding(s,
            (-(s.selected_tag.gap*2)+beautiful.fixed_outside_gap_amount) or 0)
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

-- When a client requests a new screen, and update the old_screen while we're at it
client.connect_signal("property::screen", function(c, old_screen)
    update_spacing_by_screen(c.screen)
    if old_screen then update_spacing_by_screen(old_screen) end
end)

local autorun_path = string.format("%s/awesome/autorun.sh", gears.filesystem.get_configuration_dir())
awful.spawn.with_shell(string.format([[[-e %s] && %s]], autorun_path, autorun_path))

