-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
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
          { 'harpoon_index' },
          { 'diagnostics' },
          { 'git_status', highlight = 'NeoTreeDimText' },
        },
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
      show_scrolled_off_parent_node = false,
      content_layout = 'center',
      tabs_layout = 'equal',
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
