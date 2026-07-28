-- Special workspace toggle utility (hyprws)
local vars = require("variables")
local M = {}

-- Deep match window properties (handles nested fields like workspace.name)
local function deep_match(actual, expected)
	if type(expected) == "table" then
		if type(actual) ~= "table" and type(actual) ~= "userdata" then
			return false
		end
		for key, sub_expected in pairs(expected) do
			if not deep_match(actual[key], sub_expected) then
				return false
			end
		end
		return true
	else
		return actual and string.find(tostring(actual):lower(), tostring(expected):lower(), 1, true) ~= nil
	end
end

-- Check open windows for matching client rules
local function get_clients(clients, app, target_special)
	local matched = {}
	for _, window in ipairs(clients) do
		for _, rule in ipairs(app.match or {}) do
			local is_match = true
			for key, expected in pairs(rule) do
				if not deep_match(window[key], expected) then
					is_match = false
					break
				end
			end
			if is_match then
				local ws_name = window.workspace and window.workspace.name
				table.insert(matched, {
					window = window,
					is_in_place = (ws_name == "special:" .. target_special),
				})
				break
			end
		end
	end
	return #matched > 0, matched
end

-- Toggle special workspace
function M.toggle(special_workspace)
	return function()
		local active_workspace = hl.get_active_special_workspace()

		-- Generic specialws toggle
		if special_workspace == "specialws" then
			local target = active_workspace and active_workspace.name:gsub("^special:", "") or "special"
			return hl.dispatch(hl.dsp.workspace.toggle_special(target))
		end

		local on_correct_ws = active_workspace and active_workspace.name == ("special:" .. special_workspace)

		-- Focus target special workspace if not active
		if not on_correct_ws then
			hl.dispatch(hl.dsp.focus({ workspace = "special:" .. special_workspace }))
		end

		-- Spawn missing apps or move stray windows
		local toggles = vars.toggles or {}
		local apps = toggles[special_workspace]
		if apps then
			local clients = hl.get_windows() or {}
			local target_ws = "special:" .. special_workspace

			for _, app in pairs(apps) do
				if app.enable ~= false then
					local is_running, matched_clients = get_clients(clients, app, special_workspace)

					if not is_running then
						if app.command then
							hl.dispatch(hl.dsp.exec_cmd(app.command, { workspace = target_ws }))
						end
					elseif app.move then
						for _, client in ipairs(matched_clients) do
							if not client.is_in_place then
								hl.dispatch(
									hl.dsp.window.move({ window = client.window, workspace = target_ws, silent = true })
								)
							end
						end
					end
				end
			end
		end

		-- Toggle workspace off if it was already active
		if on_correct_ws then
			hl.dispatch(hl.dsp.workspace.toggle_special(special_workspace))
		end
	end
end

return M
