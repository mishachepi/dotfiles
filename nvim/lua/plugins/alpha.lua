return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local logo = [[
          /\
         /**\
        /****\   /\
       /      \ /**\
      /  /\    /    \
     /  /  \  /      \
    /  /    \/ /\     \
   /  /      \/  \/\   \
__/__/_______/___/__\___\___
    ]]
    opts.section.header.val = vim.split(logo, "\n", { trimempty = true })
  end,
}
