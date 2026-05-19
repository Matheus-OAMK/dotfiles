hl.on("hyprland.start", function()
	-- Clipboard history
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	-- Polkit authentication agent (GUI privilege escalation) for example promptig for password when opening another drive
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	-- Keyring
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")

	-- TMUX
	hl.exec_cmd("tmux new-session -d")

	-- Waybar
	hl.exec_cmd("waybar")

	-- Wallpaper daemon
	hl.exec_cmd("awww-daemon")

	-- Voice dictation
	hl.exec_cmd("voxtype daemon")

	-- Auto delete trash 60 days old
	hl.exec_cmd("trash-empty 60")
end)
