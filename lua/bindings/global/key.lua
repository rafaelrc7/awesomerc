local awful = require "awful"
local hotkeys_popup = require "awful.hotkeys_popup"
require "awful.hotkeys_popup.keys"
local menubar = require "menubar"

local apps = require "config.apps"
local mod = require "bindings.mod"
local widgets = require "widgets"

menubar.utils.terminal = apps.terminal

awful.keyboard.append_global_keybindings {

	-- AWESOME --

	awful.key {
		modifiers	= { mod.alt, mod.super },
		key			= "s",
		description	= "show help",
		group		= "awesome",
		on_press	= hotkeys_popup.show_help,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "w",
		description	= "show main menu",
		group		= "awesome",
		on_press	= function() widgets.mainmenu:show() end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl },
		key			= "r",
		description	= "reload awesome",
		group		= "awesome",
		on_press	= awesome.restart,
	},
	awful.key {
		modifiers	= { mod.super, mod.shift },
		key			= "q",
		description	= "quit awesome",
		group		= "awesome",
		on_press	= awesome.quit,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "x",
		description	= "lua execute prompt",
		group		= "awesome",
		on_press	= function()
			awful.prompt.run {
				prompt = "Run lua code: ",
				textbox = awful.screen.focused().promptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval"
			}
		end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "b",
		description	= "toggle wibox",
		group		= "awesome",
		on_press	= function()
			for s in screen do
				s.wibox.visible = not s.wibox.visible
			end
		end,
	},

	-- LAUNCHER --

	awful.key {
		modifiers	= { mod.super, mod.shift },
		key			= "Return",
		description	= "open a terminal",
		group		= "launcher",
		on_press	= function() awful.spawn(apps.terminal) end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "r",
		description	= "run prompt",
		group		= "launcher",
		on_press	= function() awful.screen.focused().promptbox:run() end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "p",
		description	= "show the menubar",
		group		= "launcher",
		on_press	= function() menubar.show() end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "q",
		description	= "open web browser: " .. apps.browser,
		group		= "launcher",
		on_press	= function() awful.spawn(apps.browser) end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "e",
		description	= "open file browser: " .. apps.explorer,
		group		= "launcher",
		on_press	= function() awful.spawn(apps.explorer) end,
	},

	-- TAG --

	awful.key {
		modifiers	= { mod.super },
		key			= "Left",
		description	= "view previous",
		group		= "tag",
		on_press	= awful.tag.viewprev,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "Right",
		description	= "view next",
		group		= "tag",
		on_press	= awful.tag.viewnext,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "Escape",
		description	= "go back",
		group		= "tag",
		on_press	= awful.tag.history.restore,
	},

	-- CLIENT FOCUS --

	awful.key {
		modifiers	= { mod.super },
		key			= "j",
		description	= "focus next by index",
		group		= "client",
		on_press	= function() awful.client.focus.byidx(1) end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "k",
		description	= "focus previous by index",
		group		= "client",
		on_press	= function() awful.client.focus.byidx(-1) end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "Tab",
		description	= "go back",
		group		= "client",
		on_press	= function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl },
		key			= "j",
		description	= "focus the next screen",
		group		= "screen",
		on_press	= function() awful.screen.focus_relative(1) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl },
		key			= "k",
		description	= "focus the previous screen",
		group		= "screen",
		on_press	= function() awful.screen.focus_relative(-1) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl },
		key			= "n",
		description	= "restore minimised",
		group		= "client",
		on_press	= function()
			local c = awful.client.restore()
			if c then c:active { raise = true, context = "key.unminimize" } end
		end,
	},

	-- LAYOUT --

	awful.key {
		modifiers	= { mod.super, mod.shift },
		key			= "j",
		description	= "swap with next client by index",
		group		= "client",
		on_press	= function() awful.client.swap.byidx(1) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.shift },
		key			= "k",
		description	= "swap with previous client by index",
		group		= "client",
		on_press	= function() awful.client.swap.byidx(-1) end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "u",
		description	= "jump to urgent client",
		group		= "client",
		on_press	= awful.client.urgent.jumpto,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "l",
		description	= "increase master width factor",
		group		= "layout",
		on_press	= function() awful.tag.incmwfact(0.05) end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "h",
		description	= "decrease master width factor",
		group		= "layout",
		on_press	= function() awful.tag.incmwfact(-0.05) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.shift },
		key			= "h",
		description	= "increase the number of master clients",
		group		= "layout",
		on_press	= function() awful.tag.incnmaster(1, nil, true) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.shift },
		key			= "l",
		description	= "decrease the number of master clients",
		group		= "layout",
		on_press	= function() awful.tag.incnmaster(-1, nil, true) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl },
		key			= "h",
		description	= "increase the number of columns",
		group		= "layout",
		on_press	= function() awful.tag.incncol(1, nil, true) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl },
		key			= "l",
		description	= "decrease the number of columns",
		group		= "layout",
		on_press	= function() awful.tag.incncol(-1, nil, true) end,
	},
	awful.key {
		modifiers	= { mod.super },
		key			= "space",
		description	= "select next",
		group		= "layout",
		on_press	= function() awful.layout.inc(1) end,
	},
	awful.key {
		modifiers	= { mod.super, mod.shift },
		key			= "space",
		description	= "select previous",
		group		= "layout",
		on_press	= function() awful.layout.inc(-1) end,
	},

	-- TAG NUMBER KEYS --

	awful.key {
		modifiers	= { mod.super },
		keygroup	= "numrow",
		description	= "only view tag",
		group		= "tag",
		on_press	= function(idx)
			local screen = awful.screen.focused()
			local tag = screen.tags[idx]
			if tag then tag:view_only(tag) end
		end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl },
		keygroup	= "numrow",
		description	= "toggle tag",
		group		= "tag",
		on_press	= function(idx)
			local screen = awful.screen.focused()
			local tag = screen.tags[idx]
			if tag then awful.tag.viewtoggle(tag) end
		end,
	},
	awful.key {
		modifiers	= { mod.super, mod.shift },
		keygroup	= "numrow",
		description	= "move focused client to tag",
		group		= "tag",
		on_press	= function(idx)
			if client.focus then
				local tag = client.focus.screen.tags[idx]
				if tag then client.focus:move_to_tag(tag) end
			end
		end,
	},
	awful.key {
		modifiers	= { mod.super, mod.ctrl, mod.shift },
		keygroup	= "numrow",
		description	= "toggle focused client on tag",
		group		= "tag",
		on_press	= function(idx)
			if client.focus then
				local tag = client.focus.screen.tags[idx]
				if tag then client.focus:toggle_tag(tag) end
			end
		end,
	},
	awful.key {
		modifiers	= { mod.super },
		keygroup	= "numpad",
		description	= "select layout directly",
		group		= "layout",
		on_press	= function(idx)
			local tag = awful.screen.focused().selected_tag
			if tag then
				tag.layout = tag.layouts[idx] or tag.layout
			end
		end,
	},

	-- MISC --
	awful.key {
		modifiers	= { },
		key			= "Print",
		description	= "Take screenshot",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.screenshot) end,
	},
	awful.key {
		modifiers	= { mod.ctrl, mod.alt },
		key			= "l",
		description	= "Lock screen",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.lockscreen) end,
	},

	-- brightness --
	awful.key {
		modifiers	= { },
		key			= "XF86MonBrightnessUp",
		description	= "Increase screen brightness",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.bright.inc) end,
	},
	awful.key {
		modifiers	= { },
		key			= "XF86MonBrightnessDown",
		description	= "Decrease screen brightness",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.bright.dec) end,
	},

	-- volume --
	awful.key {
		modifiers	= { },
		key			= "XF86AudioRaiseVolume",
		description	= "Raise volume",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.volume.inc) end,
	},
	awful.key {
		modifiers	= { },
		key			= "XF86AudioLowerVolume",
		description	= "Lower volume",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.volume.dec) end,
	},
	awful.key {
		modifiers	= { },
		key			= "XF86AudioMute",
		description	= "Toggle mute",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.volume.mute) end,
	},

	awful.key {
		modifiers	= { mod.alt, mod.super },
		key			= "Up",
		description	= "Raise volume",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.volume.inc) end,
	},
	awful.key {
		modifiers	= { mod.alt, mod.super },
		key			= "Down",
		description	= "Lower volume",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.volume.dec) end,
	},
	awful.key {
		modifiers	= { mod.alt, mod.super },
		key			= "m",
		description	= "Toggle mute",
		group		= "hotkeys",
		on_press	= function() awful.spawn.with_shell(apps.volume.mute) end,
	},
}

