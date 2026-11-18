-- fff handles file finding and live grep; the snacks picker (snacks-picker.lua) keeps everything else.

-- Like fzf-lua's cwd_prompt: prefer a cwd-relative path, then ~, and only
-- abbreviate long paths. Keep the final directory name intact.
local function directory_prompt(cwd)
	local dir = vim.fs.normalize(vim.fn.fnamemodify(cwd, ":p"))
	local current = vim.fs.normalize(vim.fn.getcwd())
	local prefix = current == "/" and "/" or current .. "/"
	if dir ~= current and vim.startswith(dir, prefix) then
		dir = dir:sub(#prefix + 1)
	else
		dir = vim.fn.fnamemodify(dir, ":~")
	end
	if vim.fn.strchars(dir) >= 40 then
		dir = vim.fn.pathshorten(dir)
	end
	return dir:gsub("/+$", "") .. "/ "
end

local function find_files(cwd)
	require("fff").find_files({
		cwd = cwd,
		base_path = cwd,
		title = "Files in " .. vim.fn.fnamemodify(cwd, ":t"),
		prompt = directory_prompt(cwd),
	})
end

local function live_grep(cwd)
	require("fff").live_grep({ cwd = cwd, base_path = cwd, prompt = directory_prompt(cwd) })
end

local function grep_cword(cwd)
	require("fff").live_grep_under_cursor({ cwd = cwd, base_path = cwd, prompt = directory_prompt(cwd) })
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
		local ns = vim.api.nvim_create_namespace("fff_directory_prompt")
		local group = vim.api.nvim_create_augroup("FFFPickerUI", { clear = true })
		-- FileType also fires for resumed buffers, unlike FFFOpen.
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = { "fff_input", "fff_list", "fff_preview" },
			callback = function(event)
				local buf = event.buf
				-- Wait until fff has installed its own mappings and prompt.
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(buf) or vim.b[buf].fff_ui_setup then
						return
					end
					vim.b[buf].fff_ui_setup = true
					vim.keymap.set("n", "<C-t>", open_in_trouble, { buffer = buf })
					if vim.bo[buf].filetype ~= "fff_input" then
						return
					end
					local function highlight_prompt()
						if not vim.api.nvim_buf_is_valid(buf) then
							return
						end
						vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
							id = 1,
							end_col = #vim.fn.prompt_getprompt(buf),
							hl_group = "Special",
							priority = 200,
							right_gravity = false,
							end_right_gravity = false,
						})
					end
					highlight_prompt()
					vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
						group = group,
						buffer = buf,
						callback = highlight_prompt,
					})
				end)
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "FFFClose",
			callback = function()
				vim.g.last_picker = "fff"
			end,
		})
	end,
	opts = {
		follow_symlinks = true, -- snacks: follow = true
		layout = {
			border = "rounded",
			prompt_position = "top",
			title_position = "center",
			filename_position = "center",
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
