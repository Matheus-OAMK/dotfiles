-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 2,

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
		col = {
			active_border = { colors = { Colors.primary, Colors.on_primary }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		layout = "master",
	},

	-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
	dwindle = {
		preserve_split = true, -- You probably want this
	},

	-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
	master = {
		new_status = "slave",
	},

	-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
	scrolling = {
		fullscreen_on_one_column = true,
		focus_fit_method = 1,
		column_width = 0.5,
		follow_focus = true,
		follow_min_visible = 0.0,
	},
})
