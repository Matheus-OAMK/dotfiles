local M = {}

local state_file = vim.fn.expand("~/.local/state/theme/current/colors.json")
local default_colorscheme = "catppuccin-mocha"

local transparent_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"SignColumn",
	"FoldColumn",
	"LineNr",
	"LineNrAbove",
	"LineNrBelow",
	"CursorLineNr",
	"EndOfBuffer",
	"MsgArea",
	"TabLineFill",
	"WinSeparator",
	"NeoTreeNormal",
	"NeoTreeNormalNC",
	"SnacksNormal",
	"SnacksNormalNC",
	"SnacksPickerNormal",
	"SnacksPickerBorder",
	"WhichKeyNormal",
	"TroubleNormal",
	"TroubleNormalNC",
}

local function apply_transparency()
	for _, group in ipairs(transparent_groups) do
		local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
		hl.bg = "NONE"
		hl.ctermbg = "NONE"
		vim.api.nvim_set_hl(0, group, hl)
	end
end

local themes = {
	["ayu-dark"] = "ayu-dark",
	["ayu-mirage"] = "ayu-mirage",
	["catppuccin-frappe"] = "catppuccin-frappe",
	["catppuccin-macchiato"] = "catppuccin-macchiato",
	["catppuccin-mocha"] = "catppuccin-mocha",
	["dracula"] = "dracula",
	["everforest-dark-hard"] = function()
		vim.g.everforest_background = "hard"
		vim.cmd.colorscheme("everforest")
	end,
	["everforest-dark-medium"] = function()
		vim.g.everforest_background = "medium"
		vim.cmd.colorscheme("everforest")
	end,
	["everforest-dark-soft"] = function()
		vim.g.everforest_background = "soft"
		vim.cmd.colorscheme("everforest")
	end,
	["gruvbox-dark"] = "gruvbox",
	["gruvbox-material-dark-hard"] = function()
		vim.g.gruvbox_material_background = "hard"
		vim.cmd.colorscheme("gruvbox-material")
	end,
	["gruvbox-material-dark-medium"] = function()
		vim.g.gruvbox_material_background = "medium"
		vim.cmd.colorscheme("gruvbox-material")
	end,
	["gruvbox-material-dark-soft"] = function()
		vim.g.gruvbox_material_background = "soft"
		vim.cmd.colorscheme("gruvbox-material")
	end,
	["kanagawa-dragon"] = "kanagawa-dragon",
	["kanagawa-wave"] = "kanagawa-wave",
	["nord"] = "nord",
	["ristretto"] = "monokai-pro-ristretto",
	["rose-pine"] = "rose-pine",
	["solarized-dark"] = "solarized",
	["tokyo-night-moon"] = "tokyonight-moon",
	["tokyo-night-night"] = "tokyonight-night",
	["tokyo-night-storm"] = "tokyonight-storm",
}

local function read_state()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local raw = f:read("*a")
	f:close()
	local ok, data = pcall(vim.json.decode, raw)
	if not ok or type(data) ~= "table" then
		return nil
	end
	return data
end

local function apply_fallback(data)
	if not (data and data.background and data.foreground) then
		return false
	end
	local ok, base16 = pcall(require, "mini.base16")
	if not ok then
		return false
	end
	base16.setup({
		palette = {
			base00 = data.background,
			base01 = data.surface0 or data.background,
			base02 = data.surface1 or data.surface0 or data.background,
			base03 = data.muted or data.subtle or data.foreground,
			base04 = data.subtle or data.foreground,
			base05 = data.foreground,
			base06 = data.foreground,
			base07 = data.foreground,
			base08 = data.red or data.foreground,
			base09 = data.orange or data.yellow or data.foreground,
			base0A = data.yellow or data.foreground,
			base0B = data.green or data.foreground,
			base0C = data.cyan or data.foreground,
			base0D = data.blue or data.accent or data.foreground,
			base0E = data.magenta or data.secondary or data.foreground,
			base0F = data.secondary or data.orange or data.foreground,
		},
	})
	vim.g.colors_name = "base16-" .. tostring(data.theme or "custom")
	vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name })
	return true
end

function M.apply()
	local data = read_state()
	if not data then
		local ok, err = pcall(vim.cmd.colorscheme, default_colorscheme)
		if not ok then
			vim.notify("theme: failed to apply default colorscheme: " .. tostring(err), vim.log.levels.WARN)
		end
		return
	end

	if data.mode == "light" or data.mode == "dark" then
		vim.o.background = data.mode
	end

	local entry = themes[data.theme]
	local ok, err = false, nil
	if type(entry) == "string" then
		ok, err = pcall(vim.cmd.colorscheme, entry)
	elseif type(entry) == "function" then
		ok, err = pcall(entry)
	end

	if not ok then
		if entry ~= nil then
			vim.notify(
				"theme: failed to apply '" .. tostring(data.theme) .. "', falling back: " .. tostring(err),
				vim.log.levels.WARN
			)
		end
		if not apply_fallback(data) then
			pcall(vim.cmd.colorscheme, default_colorscheme)
		end
	end
end

function M.setup()
	vim.opt.winborder = "rounded"

	local group = vim.api.nvim_create_augroup("system-theme-sync", { clear = true })

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = apply_transparency,
	})

	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "VeryLazy",
		callback = apply_transparency,
	})

	vim.api.nvim_create_autocmd("Signal", {
		group = group,
		pattern = "SIGUSR1",
		callback = function()
			vim.schedule(M.apply)
		end,
	})

	M.apply()
end

return M
