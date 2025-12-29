-- nvim-dap configuration for Python debugging
-- This works with Neovim from Homebrew (no need for Python3+ compiled in)

local dap = require('dap')
local dapui = require('dapui')
local dap_virtual_text = require('nvim-dap-virtual-text')

-- Setup nvim-dap-virtual-text (shows variable values inline)
dap_virtual_text.setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  clear_on_continue = false,
})

-- Setup dap-ui
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "⏸",
      play = "▶",
      step_into = "⏎",
      step_over = "⏭",
      step_out = "⏮",
      step_back = "b",
      run_last = "▶▶",
      terminate = "⏹",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

-- Python debugger configuration
dap.adapters.python = {
  type = 'executable',
  command = 'python3',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    python = function()
      -- Try to use virtualenv python if available
      local venv = vim.fn.getcwd() .. '/.venv'
      if vim.fn.isdirectory(venv) == 1 then
        return venv .. '/bin/python'
      end
      return 'python3'
    end,
    console = 'integratedTerminal',
    justMyCode = false,
  },
  {
    type = 'python',
    request = 'attach',
    name = 'Attach to process',
    processId = require('dap.utils').pick_process,
    python = function()
      local venv = vim.fn.getcwd() .. '/.venv'
      if vim.fn.isdirectory(venv) == 1 then
        return venv .. '/bin/python'
      end
      return 'python3'
    end,
  },
}

-- Auto open/close dap-ui
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- Setup nvim-dap-python (installs debugpy automatically)
require('dap-python').setup('python3')

