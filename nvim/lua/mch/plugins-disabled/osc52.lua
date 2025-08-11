return {
  "ojroques/nvim-osc52",
  config = function()
    require("osc52").setup {
      max_length = 0,
      silent = false,
      trim = false,
    }
  end,
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      require("osc52").copy_register("+")
    end,
  })
}

