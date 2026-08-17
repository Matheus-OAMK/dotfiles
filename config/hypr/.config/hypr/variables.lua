-- Workspace & App definitions
return {
	-- Default programs
	terminal = "kitty",
	fileManager = "nautilus",
	browser = "brave",
	menu = "~/.config/rofi/rofilaunch.sh",
	emojiMenu = "~/.config/rofi/emoji-picker.sh",
	cliphistMenu = "~/.config/rofi/cliphist.sh",

	-- Special workspace toggles
	toggles = {
		communication = {
			vesktop = {
				enable = true,
				match = { { class = "vesktop" } },
				command = "vesktop",
				move = true,
			},
		},
		email = {
			betterbird = {
				enable = true,
				match = { { class = "betterbird" } },
				command = "betterbird",
				move = true,
			},
		},
		music = {
			spotify = {
				enable = true,
				match = { { class = "Spotify" }, { initial_title = "Spotify" } },
				command = "spicetify watch -s",
				move = true,
			},
			tidal = {
				enable = true,
				match = { { class = "tidal-hifi" }, { title = "TIDAL" } },
				command = "tidal-hifi",
				move = true,
			},
		},
		sysmon = {
			btop = {
				enable = true,
				match = { { class = "btop", title = "btop", workspace = { name = "special:sysmon" } } },
				command = "kitty --class btop --title btop btop",
			},
		},
	},
}
