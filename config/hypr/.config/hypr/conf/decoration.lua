-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
	decoration = {
		rounding = 0,
		rounding_power = 3,

		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
		blur = {
			enabled = true,
			size = 15,
			passes = 2,
			noise = 0.08,
			xray = false,

			special = false,
			popups = true,
			input_methods = true,
		},
	},
})
