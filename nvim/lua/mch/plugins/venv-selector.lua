return {
  'linux-cultist/venv-selector.nvim',
  dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
  opts = { -- this can be an empty lua table - just showing below for clarity.
    search = {}, -- if you add your own searches, they go here.
    options = {} -- if you add plugin options, they go here.
  },
  ft = "python", -- Load when opening Python files
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { '<leader>cv', '<cmd>VenvSelect<cr>', desc = 'Select VirtualEnv' },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    -- { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
  },
}
