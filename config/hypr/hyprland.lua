-- Config

require("colors")
require("conf.env")
require("conf.execs")
require("conf.decoration")
require("conf.animations")
require("conf.input")
require("conf.general")
require("conf.keybinds")
require("conf.voxtype-submap")

-- Custom
require("conf.custom-desktop")

-- Ref https://wiki.hypr.land/Configuring/Variables/#misc
-- DISABLE random wallpaper (not sure why these aren't defaults)
hl.config({
	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

-- # Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- f[-1], f[0], f[1], f[2] - fullscreen state of the workspace. -1: no fullscreen, 0: fullscreen, 1: maximized, 2, fullscreen without fullscreen state sent to the window.

-- # "Smart gaps" / "No gaps when only"
hl.workspace_rule({
	workspace = "f[1]",
	gaps_out = 0,
	gaps_in = 0,
})
hl.window_rule({
	name = "no-gaps-f1",
	match = {
		float = false,
		workspace = "f[1]",
	},
	border_size = 0,
	rounding = 0,
})

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

--  See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
--  See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules

-- Example windowrules that are useful

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = {
		class = "hyprland-run",
	},
	move = "20 monitor_h-120",
	float = true,
})

-- TAKEN FROM HYDE
--  Add blur to wlogout
hl.layer_rule({
	match = { namespace = "logout_dialog" },
	blur = true,
})

hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0,
})

-- Float and center nwg-look
hl.window_rule({
	match = {
		class = "nwg-look",
	},
	float = true,
	size = { "monitor_w*0.4", "monitor_h*0.6" },
	center = true,
})

-- # Pavu-control
hl.window_rule({
	match = {
		class = "org\\.pulseaudio\\.pavucontrol|yad-icon-browser",
	},
	float = true,
	size = { "monitor_w*0.4", "monitor_h*0.6" },
	center = true,
})

--  nmtui
hl.window_rule({
	match = {
		class = "nmtui",
	},
	float = true,
	size = { "monitor_w*0.4", "monitor_h*0.6" },
	center = true,
})

--  bluetui
hl.window_rule({
	match = {
		class = "bluetui",
	},
	float = true,
	size = { "monitor_w*0.4", "monitor_h*0.6" },
	center = true,
})

-- # Discord clients and whastspp
hl.window_rule({
	match = {
		class = "discord|equibop|vesktop|whatsapp",
	},
	workspace = "special:communication",
})

-- Satty (screenshot editor)
hl.window_rule({
	match = {
		class = "^(com.gabm.satty)$",
	},
	float = true,
	center = true,
})

-- WARN: Why do we have this here? revisit
--  Opacity for windows
hl.window_rule({
	match = {
		fullscreen = false,
	},
	opacity = "0.9 override 0.85 override",
})

-- Brave-browser
hl.window_rule({
	match = {
		class = "^(brave-browser)$",
	},
	opacity = "0.90 override 0.90 override 1",
})
