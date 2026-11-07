return {
  {
    "linux-cultist/venv-selector.nvim",
    enabled = false,
  },
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      { "<leader>dPt", false },
      { "<leader>dPc", false },
    },
    -- Prevent LazyVim lang.python from calling setup("debugpy-adapter").
    -- Real setup lives on nvim-dap below so nvim-dap is on the rtp first.
    config = function() end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>d", "", desc = "+debug" },
    },
    config = function()
      local python_uv = require("config.python_uv")
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      require("dapui").setup({})
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      dap_python.setup("uv")
      dap_python.test_runner = "pytest"
      dap_python.resolve_python = function()
        return python_uv.venv_python()
      end

      local uv_python = python_uv.uv_python_cmd()
      for _, config in ipairs(dap.configurations.python or {}) do
        if config.request == "launch" then
          config.python = uv_python
        end
      end

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local function map(lhs, rhs, desc, mode)
        vim.keymap.set(mode or "n", lhs, rhs, { desc = desc, noremap = true, silent = true })
      end

      local function uv_config()
        return { python = python_uv.uv_python_cmd() }
      end

      local function with_ready(need_pytest, fn)
        return function()
          if dap.session() then
            return fn()
          end
          if vim.bo.filetype == "python" then
            if not python_uv.ensure_debug_ready({ need_pytest = need_pytest }) then
              return
            end
          end
          return fn()
        end
      end

      map(
        "<leader>dk",
        with_ready(true, function()
          dap_python.test_class({ config = uv_config() })
        end),
        "Debug Test Class"
      )
      map(
        "<leader>dm",
        with_ready(true, function()
          dap_python.test_method({ config = uv_config() })
        end),
        "Debug Test Method"
      )
      map("<leader>db", function()
        dap.toggle_breakpoint()
      end, "Toggle Breakpoint")
      map("<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "Conditional Breakpoint")
      map(
        "<leader>dc",
        with_ready(false, function()
          dap.continue()
        end),
        "Continue / Start"
      )
      map(
        "<leader>df",
        with_ready(false, function()
          dap.run({
            type = "python",
            request = "launch",
            name = "file",
            program = "${file}",
            console = "integratedTerminal",
            python = python_uv.uv_python_cmd(),
          })
        end),
        "Debug File"
      )
      map(
        "<leader>ds",
        with_ready(false, function()
          dap_python.debug_selection({ config = uv_config() })
        end),
        "Debug Selection",
        { "n", "v" }
      )
      map("<leader>dl", function()
        dap.run_last()
      end, "Debug Last")
      map("<leader>do", function()
        dap.step_over()
      end, "Step Over")
      map("<leader>di", function()
        dap.step_into()
      end, "Step Into")
      map("<leader>dO", function()
        dap.step_out()
      end, "Step Out")
      map("<leader>dq", function()
        dap.terminate()
      end, "Terminate")
      map("<leader>du", function()
        dapui.toggle()
      end, "Toggle DAP UI")
      map("<leader>dE", function()
        if python_uv.ensure_debug_ready({ need_pytest = true }) then
          vim.notify("uv Python debug environment looks ready", vim.log.levels.INFO)
        end
      end, "Ensure uv Debug Deps")
    end,
  },
}
