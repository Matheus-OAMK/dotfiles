-- fff handles file finding and live grep; the snacks picker (snacks-picker.lua) keeps everything else.

-- Which fff picker opened last, so <leader>sr can resume it (see snacks-picker.lua)
local function remember(mode)
	vim.g.fff_last_mode = mode
end

local function find_files(cwd)
	remember("files")
	require("fff").find_files_in_dir(cwd)
end

local function live_grep(cwd)
	remember("grep")
	require("fff").live_grep({ cwd = cwd })
end

local function grep_cword(cwd)
	remember("grep")
	require("fff").live_grep_under_cursor({ cwd = cwd })
end

-- Like snacks' ctrl-t: open the selected entries (or the current one) in Trouble.
-- fff has no Trouble action, so this reads fff's picker state (not public API)
local function open_in_trouble()
	local picker = require("fff.picker_ui.picker_ui")
	local state = picker.state
	local to_abs = require("fff.utils").canonicalize_fff_path

	local entries = {}
	if state.mode == "grep" then
		for _, item in pairs(state.selected_items) do
			entries[#entries + 1] = item
		end
	else
		for relative_path in pairs(state.selected_files) do
			entries[#entries + 1] = { relative_path = relative_path }
		end
	end
	if #entries == 0 then
		entries = { state.filtered_items[state.cursor] }
	end

	local qf_list = {}
	for _, item in ipairs(entries) do
		local filename = to_abs(item.relative_path)
		if filename then
			qf_list[#qf_list + 1] = {
				filename = filename,
				lnum = item.line_number or 1,
				col = (item.col or 0) + 1,
				text = item.line_content or vim.fn.fnamemodify(filename, ":."),
			}
		end
	end

	vim.cmd("stopinsert")
	picker.close()

	if #qf_list > 0 then
		vim.fn.setqflist(qf_list)
		vim.cmd("Trouble qflist open")
	end
end

return {
	"dmtrKovalenko/fff",
	build = function()
		-- downloads a prebuilt binary or falls back to cargo build
		require("fff.download").download_or_build_binary()
	end,
	lazy = false, -- fff lazy-initialises itself
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "FFFClose",
			callback = function()
				vim.g.last_picker = "fff"
			end,
		})
	end,
	opts = {
		follow_symlinks = true, -- snacks: follow = true
		layout = {
			-- Match the snacks picker: 90% of the screen, prompt on top, preview on the right,
			-- preview below the list under 120 columns
			height = 0.9,
			width = 0.9,
			border = "rounded",
			prompt_position = "top",
			flex = { size = 120, wrap = "bottom" },
		},
		preview = {
			line_numbers = true,
		},
		git = {
			status_text_color = true, -- color filenames by git status, not just the sign column
		},
		mappings = {
			i = {
				["<C-t>"] = open_in_trouble, -- replaces fff's open-in-tab, as in snacks
			},
		},
	},
	keys = {
		-- ***** Find *****
		{
			"<leader>ff",
			function()
				find_files(MyUtils.root.get())
			end,
			desc = "[F]ind [F]iles (root)",
		},
		{
			"<leader>fF",
			function()
				find_files(vim.uv.cwd())
			end,
			desc = "[S]earch [F]iles (cwd)",
		},
		{
			"<leader>fn",
			function()
				find_files(vim.fn.stdpath("config"))
			end,
			desc = "[F]ind [N]eovim Config",
		},

		-- ***** Search *****
		{
			"<leader>sg",
			function()
				live_grep(MyUtils.root.get())
			end,
			desc = "[S]earch by [G]rep (root)",
		},
		{
			"<leader>sG",
			function()
				live_grep(vim.uv.cwd())
			end,
			desc = "[S]earch by [G]rep (cwd)",
		},
		{
			"<leader>sw",
			function()
				grep_cword(MyUtils.root.get())
			end,
			mode = { "n", "x" },
			desc = "[S]earch Current [W]ord (root)",
		},
		{
			"<leader>sW",
			function()
				grep_cword(vim.uv.cwd())
			end,
			mode = { "n", "x" },
			desc = "[S]earch Current [W]ord (cwd)",
		},
	},
}
