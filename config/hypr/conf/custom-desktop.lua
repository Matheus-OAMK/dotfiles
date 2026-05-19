-- Main monitor
hl.monitor({
	output = "DP-1",
	mode = "2560x1440@359.98",
	position = "1920x0",
	scale = 1,
	bitdepth = 10,
})
-- Secondary Monitor
hl.monitor({
	output = "DP-2",
	mode = "1920x1080@144.00",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	cm = "auto",
})

-- Pin workspaces 1-10 to monitors
hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-2" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
hl.workspace_rule({ workspace = "7", monitor = "DP-1" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2" })
hl.workspace_rule({ workspace = "9", monitor = "DP-1" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2" })

hl.config({
	misc = {
		vrr = 3, -- VRR only in fullscreen with `Game` or `Video`
	},
})

hl.config({
	render = {
		cm_auto_hdr = 1,
	},
})

-- NVIDIA
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
