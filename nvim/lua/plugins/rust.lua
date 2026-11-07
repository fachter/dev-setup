return {
  {
    "mrcjkb/rustaceanvim",
    -- To avoid being surprised by breaking changes,
    -- I recommend you set a version range
    version = "^9",
    -- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
    -- No need for lazy.nvim to lazy-load it.
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- rustaceanvim owns rust-analyzer. Letting lspconfig/mason also
        -- start rust_analyzer duplicates completions and diagnostics.
        rust_analyzer = { enabled = false },
      },
    },
  },
}
