return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      require('catppuccin').setup {
        flavour = 'auto', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        -- transparent_background = false, -- disables setting the background color.
        -- show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        -- term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        -- dim_inactive = {
        --   enabled = false, -- dims the background color of inactive window
        --   shade = 'dark',
        --   percentage = 0.15, -- percentage of the shade to apply to the inactive window
        -- },
        -- no_italic = false, -- Force no italic
        -- no_bold = false, -- Force no bold
        -- no_underline = false, -- Force no underline
        -- styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        --   comments = { 'italic' }, -- Change the style of comments
        --   conditionals = { 'italic' },
        --   loops = {},
        --   functions = {},
        --   keywords = {},
        --   strings = {},
        --   variables = {},
        --   numbers = {},
        --   booleans = {},
        --   properties = {},
        --   types = {},
        --   operators = {},
        --   -- miscs = {}, -- Uncomment to turn off hard-coded styles
        -- },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
          barbecue = {
            dim_dirname = true, -- directory name is dimmed by default
            bold_basename = true,
            dim_context = false,
            alt_background = false,
          },
          cmp = true,
          colorful_winsep = {
            enabled = true,
            color = 'teal',
          },
          -- dap = true,
          -- dap_ui = true,
          gitsigns = true,
          harpoon = true,
          indent_blankline = {
            enabled = true,
            scope_color = 'text', -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = false,
          },
          lsp_trouble = true,
          mason = true,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
              ok = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
              ok = { 'underline' },
            },
            inlay_hints = {
              background = true,
            },
          },
          treesitter = true,
          which_key = true,
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }

      -- setup must be called before loading
      vim.cmd.colorscheme 'catppuccin'

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
