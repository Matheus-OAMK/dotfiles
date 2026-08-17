
-- utils/root.lua
local M = {}

-- Order of root detection: LSP → pattern → cwd
M.spec = { "lsp", { ".git", "lua" }, "cwd" }

-- --- Core function to get project root
function M.get(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local path = M.bufpath(buf)
  if not path or path == "" then
    return vim.uv.cwd()
  end

  -- 1️⃣ Try LSP root(s)
  for _, client in pairs(vim.lsp.get_clients({ bufnr = buf })) do
    local roots = {}
    if client.config.workspace_folders then
      for _, ws in pairs(client.config.workspace_folders) do
        roots[#roots + 1] = vim.uri_to_fname(ws.uri)
      end
    end
    if client.root_dir then
      roots[#roots + 1] = client.root_dir
    end
    for _, root in ipairs(roots) do
      if path:find(root, 1, true) == 1 then
        return root
      end
    end
  end

  -- 2️⃣ Try common patterns like .git or lua
  for _, p in ipairs({ ".git", "lua" }) do
    local found = vim.fs.find(p, { path = path, upward = true })[1]
    if found then
      return vim.fs.dirname(found)
    end
  end

  -- 3️⃣ Fallback to cwd
  return vim.uv.cwd()
end

-- Helper: get real path of buffer
function M.bufpath(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return nil
  end
  return vim.uv.fs_realpath(name)
end

return M
