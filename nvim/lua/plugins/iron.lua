return {
  {
    "Vigemus/iron.nvim",
    keys = {
      { "<leader>r", "", desc = "+repl" },
    },
    config = function()
      local python_uv = require("config.python_uv")
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = function()
                return python_uv.repl_cmd()
              end,
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
              env = { PYTHON_BASIC_REPL = "1" },
            },
          },
          repl_filetype = function(_, ft)
            return ft
          end,
          dap_integration = true,
          repl_open_cmd = view.bottom(40),
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      })

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
      end

      local function with_ready(fn)
        return function()
          if not python_uv.ensure_debug_ready() then
            return
          end
          return fn()
        end
      end

      map(
        "n",
        "<leader>rr",
        with_ready(function()
          vim.cmd("IronRepl")
        end),
        "Toggle REPL"
      )
      map(
        "n",
        "<leader>rR",
        with_ready(function()
          vim.cmd("IronRestart")
        end),
        "Restart REPL"
      )
      map(
        "n",
        "<leader>rl",
        with_ready(function()
          iron.send_line()
        end),
        "Send Line to REPL"
      )
      map(
        "n",
        "<leader>rf",
        with_ready(function()
          iron.send_file()
        end),
        "Send File to REPL"
      )
      map(
        "n",
        "<leader>re",
        with_ready(function()
          iron.run_motion("send_motion")
        end),
        "Send Motion to REPL"
      )
      map(
        "v",
        "<leader>re",
        with_ready(function()
          iron.visual_send()
        end),
        "Send Selection to REPL"
      )
      map(
        "n",
        "<leader>rb",
        with_ready(function()
          iron.send_code_block(false)
        end),
        "Send Code Block to REPL"
      )
      map("n", "<leader>rq", function()
        iron.close_repl()
      end, "Exit REPL")
      map("n", "<leader>rc", function()
        iron.send(nil, string.char(12))
      end, "Clear REPL")
    end,
  },
}
