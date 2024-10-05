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
    source_selector = {
      winbar = true, -- toggle to show selector on winbar
      statusline = false, -- toggle to show selector on statusline
      show_scrolled_off_parent_node = false, -- boolean
      sources = { -- table
        {
          source = 'filesystem', -- string
          display_name = ' 󰉓 Files ', -- string | nil
        },
        {
          source = 'buffers', -- string
          display_name = ' 󰈚 Buffers ', -- string | nil
        },
        {
          source = 'git_status', -- string
          display_name = ' 󰊢 Git ', -- string | nil
        },
      },
      content_layout = 'start', -- string
      tabs_layout = 'equal', -- string
      truncation_character = '…', -- string
      tabs_min_width = nil, -- int | nil
      tabs_max_width = nil, -- int | nil
      padding = 0, -- int | { left: int, right: int }
      separator = { left = '▏', right = '▕' }, -- string | { left: string, right: string, override: string | nil }
      separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
      show_separator_on_edge = false, -- boolean
      highlight_tab = 'NeoTreeTabInactive', -- string
      highlight_tab_active = 'NeoTreeTabActive', -- string
      highlight_background = 'NeoTreeTabInactive', -- string
      highlight_separator = 'NeoTreeTabSeparatorInactive', -- string
      highlight_separator_active = 'NeoTreeTabSeparatorActive', -- string
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
