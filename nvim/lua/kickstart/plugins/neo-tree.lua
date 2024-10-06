-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    'saifulapm/neotree-file-nesting-config',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          local hl = vim.api.nvim_get_hl_by_name('Cursor', true)
          hl.blend = 100
          vim.api.nvim_set_hl(0, 'Cursor', hl)
          vim.opt.guicursor:append 'a:Cursor/lCursor'
        end,
      },
      {
        event = 'neo_tree_buffer_leave',
        handler = function()
          local hl = vim.api.nvim_get_hl_by_name('Cursor', true)
          hl.blend = 0
          vim.api.nvim_set_hl(0, 'Cursor', hl)
          vim.opt.guicursor:remove 'a:Cursor/lCursor'
        end,
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      components = {
        harpoon_index = function(config, node, _)
          local harpoon_list = require('harpoon'):list()
          local path = node:get_id()
          local harpoon_key = vim.uv.cwd()

          for i, item in ipairs(harpoon_list.items) do
            local value = item.value
            if string.sub(item.value, 1, 1) ~= '/' then
              value = harpoon_key .. '/' .. item.value
            end

            if value == path then
              vim.print(path)
              return {
                text = string.format(' ⥤ %d', i), -- <-- Add your favorite harpoon like arrow here
                highlight = config.highlight or 'NeoTreeDirectoryIcon',
              }
            end
          end
          return {}
        end,
      },
      renderers = {
        file = {
          { 'icon' },
          { 'name', use_git_status_colors = true },
          { 'harpoon_index' }, --> This is what actually adds the component in where you want it
          { 'diagnostics' },
          { 'git_status', highlight = 'NeoTreeDimText' },
        },
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
      show_scrolled_off_parent_node = false,
      sources = {
        {
          source = 'filesystem',
          display_name = ' 󰉓 Files ',
        },
        {
          source = 'buffers',
          display_name = ' 󰈚 Buffers ',
        },
        {
          source = 'git_status',
          display_name = ' 󰊢 Git ',
        },
      },
      content_layout = 'start',
      tabs_layout = 'equal',
      truncation_character = '…',
      tabs_min_width = nil, -- int | nil
      tabs_max_width = nil, -- int | nil
      padding = 0, -- int | { left: int, right: int }
      separator = { left = '▏', right = '▕' }, -- string | { left: string, right: string, override: string | nil }
      separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
      show_separator_on_edge = false,
      highlight_tab = 'NeoTreeTabInactive',
      highlight_tab_active = 'NeoTreeTabActive',
      highlight_background = 'NeoTreeTabInactive',
      highlight_separator = 'NeoTreeTabSeparatorInactive',
      highlight_separator_active = 'NeoTreeTabSeparatorActive',
    },

    default_component_configs = {
      indent = {
        with_markers = false,
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
      },
    },
  },
}
