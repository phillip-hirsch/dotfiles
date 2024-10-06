return {
  {
    'olimorris/onedarkpro.nvim',
    -- priority = 1000,
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'onedark'

      local color = require 'onedarkpro.helpers'

      local colors = color.get_colors()

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = colors.gray })
    end,
  },
}
