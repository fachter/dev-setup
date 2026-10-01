return {

  -- add any tools you want to have installed below
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "uv",
        "ruff",
        "isort",
        "black",
        "shellcheck",
        "flake8",
        "ty",
        "golangci-lint",
      })
      -- LazyVim concatenates every ensure_installed list. A duplicated name
      -- that is not installed yet calls install() twice and aborts config.
      local seen, unique = {}, {}
      for _, tool in ipairs(opts.ensure_installed) do
        if not seen[tool] then
          seen[tool] = true
          unique[#unique + 1] = tool
        end
      end
      opts.ensure_installed = unique
    end,
  },
}
