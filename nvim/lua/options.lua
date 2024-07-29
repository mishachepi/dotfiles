require "nvchad.options"
-- add yours here!
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!


local function open_nvim_tree(data)
  local directory = vim.fn.isdirectory(data.file) == 1
  if not directory then
    return
  end
  vim.cmd.cd(data.file)
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


local api = require("nvim-tree.api")

local git_add = function()
  local node = api.tree.get_node_under_cursor()
  local gs = node.git_status.file

  -- If the current node is a directory get children status
  if gs == nil then
    gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
         or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
  end

  if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
    vim.cmd("silent !git add " .. node.absolute_path)
  elseif gs == "M " or gs == "A " then
    vim.cmd("silent !git restore --staged " .. node.absolute_path)
  end

  api.tree.reload()
end

vim.keymap.set('n', 'ga', git_add, { desc = "Git add" })
