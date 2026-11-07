local M = {}

local MARKERS = { "pyproject.toml", "uv.lock", ".venv" }

---@return string|nil
function M.project_root()
  local buf = vim.api.nvim_buf_get_name(0)
  local start = (buf ~= "" and vim.fs.dirname(buf)) or vim.uv.cwd()
  return vim.fs.root(start, MARKERS) or vim.uv.cwd()
end

---@return boolean
function M.has_uv()
  return vim.fn.executable("uv") == 1
end

---@return boolean
function M.has_pyproject(root)
  root = root or M.project_root()
  return root ~= nil and vim.uv.fs_stat(root .. "/pyproject.toml") ~= nil
end

---@return string|nil
function M.venv_python(root)
  root = root or M.project_root()
  if not root then
    return nil
  end
  local unix = root .. "/.venv/bin/python"
  if vim.uv.fs_stat(unix) then
    return unix
  end
  local win = root .. "/.venv/Scripts/python.exe"
  if vim.uv.fs_stat(win) then
    return win
  end
  return nil
end

---@return boolean
function M.has_venv(root)
  return M.venv_python(root) ~= nil
end

--- Interpreter command for debugpy launch configs (`python` field).
---@return string[]
function M.uv_python_cmd()
  return { "uv", "run", "--with", "debugpy", "python" }
end

--- Command used by iron.nvim (no debugpy injection).
---@return string[]
function M.repl_cmd()
  if M.has_uv() then
    return { "uv", "run", "python" }
  end
  return { "python3" }
end

---@param args string[]
---@param opts? { cwd?: string, success?: string }
function M.run_uv(args, opts)
  opts = opts or {}
  local cmd = { "uv" }
  vim.list_extend(cmd, args)
  vim.notify("Running: " .. table.concat(cmd, " "), vim.log.levels.INFO)
  vim.system(cmd, {
    cwd = opts.cwd or M.project_root(),
    text = true,
  }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        vim.notify(opts.success or ("uv " .. args[1] .. " finished"), vim.log.levels.INFO)
      else
        local err = (obj.stderr ~= nil and obj.stderr ~= "" and obj.stderr)
          or (obj.stdout ~= nil and obj.stdout ~= "" and obj.stdout)
          or "unknown error"
        vim.notify(vim.trim(err), vim.log.levels.ERROR)
      end
    end)
  end)
end

---@param mod string
---@return boolean
local function can_import(mod)
  local result = vim.system({ "uv", "run", "python", "-c", "import " .. mod }, {
    cwd = M.project_root(),
    text = true,
    timeout = 15000,
  }):wait()
  return result.code == 0
end

local function offer(prompt, items, on_choice)
  vim.ui.select(items, { prompt = prompt }, function(choice)
    if choice then
      on_choice(choice)
    end
  end)
end

---@param opts? { need_pytest?: boolean }
---@return boolean
function M.ensure_debug_ready(opts)
  opts = opts or {}
  local root = M.project_root()

  if not M.has_uv() then
    offer("uv is not on PATH", { "MasonInstall uv", "Cancel" }, function(choice)
      if choice == "MasonInstall uv" then
        vim.cmd("MasonInstall uv")
      end
    end)
    vim.notify("uv is not on PATH. Install uv, then retry.", vim.log.levels.ERROR)
    return false
  end

  if M.has_pyproject(root) and not M.has_venv(root) then
    offer("No .venv found. Sync the uv project?", { "uv sync", "Cancel" }, function(choice)
      if choice == "uv sync" then
        M.run_uv({ "sync" }, {
          cwd = root,
          success = "uv sync finished. Retry the debugger.",
        })
      end
    end)
    return false
  end

  if opts.need_pytest then
    if not M.has_pyproject(root) then
      vim.notify("pytest debugging needs a uv project (pyproject.toml).", vim.log.levels.ERROR)
      return false
    end
    if not can_import("pytest") then
      offer("pytest is missing from this environment", { "uv add --dev pytest", "Cancel" }, function(choice)
        if choice == "uv add --dev pytest" then
          M.run_uv({ "add", "--dev", "pytest" }, {
            cwd = root,
            success = "pytest installed. Retry the debugger.",
          })
        end
      end)
      return false
    end
  end

  return true
end

local setup_done = false

function M.setup()
  if setup_done then
    return
  end
  setup_done = true
  vim.api.nvim_create_user_command("UvEnsureDebug", function()
    if M.ensure_debug_ready({ need_pytest = true }) then
      vim.notify("uv Python debug environment looks ready", vim.log.levels.INFO)
    end
  end, { desc = "Ensure uv env is ready for Python debugging" })
end

M.setup()

return M
