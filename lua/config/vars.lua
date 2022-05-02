local awful = require "awful"

return {
	layouts = {
		awful.layout.suit.tile,
		awful.layout.suit.tile.top,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.spiral,
		awful.layout.suit.floating,
	},

	tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
}

