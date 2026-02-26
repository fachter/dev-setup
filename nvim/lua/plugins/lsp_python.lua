return {
  {
    "neovim/nvim-lspconfig",
    -- config = function()
    --   require("lspconfig").pyright.setup({
    --     settings = {
    --       pyright = {
    --         -- Using Ruff's import organizer
    --         disableOrganizeImports = true,
    --       },
    --       python = {
    --         analysis = {
    --           -- Ignore all files for analysis to exclusively use Ruff for linting
    --           ignore = { "*" },
    --         },
    --       },
    --     },
    --   })
    -- end,
    -- function()
    --   require("lspconfig").setup({})
    -- end,
    -- opts = {
    --   servers = {
    --     ["ruff_lsp"] = {
    --       init_options = {
    --         settings = {
    --           args = {},
    --         },
    --       },
    --     },
    --   },
    --   setup = {
    --     ["ruff_lsp"] = function(server, opts)
    --       require("lspconfig")[server].setup(opts)
    --       return true
    --     end,
    --   },
    -- },
  },
}
