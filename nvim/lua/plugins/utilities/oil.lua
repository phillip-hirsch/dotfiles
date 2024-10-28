return {
  {
    'refractalize/oil-git-status.nvim',

    dependencies = {
      'stevearc/oil.nvim',
    },

    config = true,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
    config = function()
      -- helper function to parse output
      local function parse_output(proc)
        local result = proc:wait()
        local ret = {}
        if result.code == 0 then
          for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub('/$', '')
            ret[line] = true
          end
        end
        return ret
      end

      -- build git status cache
      local function new_git_status()
        return setmetatable({}, {
          __index = function(self, key)
            local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, {
              cwd = key,
              text = true,
            })
            local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, {
              cwd = key,
              text = true,
            })
            local ret = {
              ignored = parse_output(ignore_proc),
              tracked = parse_output(tracked_proc),
            }

            rawset(self, key, ret)
            return ret
          end,
        })
      end

      local git_status = new_git_status()

      -- Clear git status cache on refresh
      local refresh = require('oil.actions').refresh
      local orig_refresh = refresh.callback
      refresh.callback = function(...)
        git_status = new_git_status()
        orig_refresh(...)
      end

      -- Declare a global function to retrieve the current directory
      function _G.get_oil_winbar()
        local dir = require('oil').get_current_dir()
        if dir then
          return vim.fn.fnamemodify(dir, ':~')
        else
          -- If there is no current directory (e.g. over ssh), just show the buffer name
          return vim.api.nvim_buf_get_name(0)
        end
      end

      require('oil').setup {
        win_options = {
          signcolumn = 'yes:2',
          winbar = '%!v:lua.get_oil_winbar()',
        },
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
          ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
          ['<C-p>'] = 'actions.preview',
          ['\\'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory', mode = 'n' },
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = false,
        view_options = {
          is_hidden_file = function(name, bufnr)
            local dir = require('oil').get_current_dir(bufnr)
            -- local is_dotfile = vim.startswith(name, '.') and name ~= '..'
            -- if no local directory (e.g. for ssh connections), just hide dotfiles
            -- if not dir then
            --   return is_dotfile
            -- end
            -- dotfiles are considered hidden unless tracked
            -- if is_dotfile then
            --   return not git_status[dir].tracked[name]
            -- else
            -- Check if file is gitignored
            return git_status[dir].ignored[name]
            -- end
          end,
        },
      }
    end,
  },
}
