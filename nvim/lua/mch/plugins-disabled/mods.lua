return {
  'ntawileh/mods.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    require('mods').setup()

    vim.keymap.set({ 'v' }, '<leader>aa', function()
      require('mods').query({})
    end, {
      desc = 'Query Mods AI with selection as context',
    })
    vim.keymap.set({ 'n' }, '<leader>aa', function()
      require('mods').query({})
    end, {
      desc = 'Query Mods AI with current buffer as context',
    })
    vim.keymap.set({ 'n' }, '<leader>aq', function()
      require('mods').query({
        exclude_context = true,
      })
    end, {
      desc = 'Query Mods AI without any buffer context',
    })
    vim.keymap.set({ 'n' }, '<leader>ac', function()
      require('mods').get_history()
    end, {
      desc = 'View AI recent conversation for this file',
    })
  end,
}
