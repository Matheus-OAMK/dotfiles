-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations

hl.config({
	animations = {
		enabled = true,
	},
})

-- Animation Curves Definition
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })

hl.animation({ leaf = "layersIn", enabled = true, speed = 2.2, bezier = "emphasizedDecel" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "emphasizedAccel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.2, bezier = "emphasizedDecel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "emphasizedAccel" })

-- Windows
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.2, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "emphasizedAccel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.2, bezier = "standard" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.2, bezier = "standard" })
hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 2.2,
	bezier = "emphasizedDecel",
	style = "slidefadevert 15%",
})
hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 1.5,
	bezier = "emphasizedAccel",
	style = "slidefadevert 15%",
})

-- Fade
hl.animation({ leaf = "fade", enabled = true, speed = 2.2, bezier = "standard" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.2, bezier = "emphasizedDecel" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "emphasizedAccel" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "standard" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "standard" })

-- Border
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "standard" })
