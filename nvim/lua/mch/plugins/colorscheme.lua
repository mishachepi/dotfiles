return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.      -- load the colorscheme here
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
