-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- 'saifulapm/neotree-file-nesting-config',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    -- recommanded config for better UI
    -- hide_root_node = true,
    -- retain_hidden_root_indent = true,
    filesystem = {
      -- filtered_items = {
      --   show_hidden_count = false,
      --   never_show = {
      --     '.DS_Store',
      --   },
      -- },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    -- default_component_configs = {
    --   indent = {
    --     with_expanders = true,
    --     expander_collapsed = '',
    --     expander_expanded = '',
    --   },
    -- },
  },
  -- config = function(_, opts)
  --   -- Adding rules from plugin
  --   opts.nesting_rules = require('neotree-file-nesting-config').nesting_rules
  --   require('neo-tree').setup(opts)
  -- end,
}
