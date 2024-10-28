return {
  'folke/trouble.nvim',
  opts = {
    modes = {
      preview_float = {
        mode = 'diagnostics',
        preview = {
          type = 'float',
          relative = 'editor',
          border = 'rounded',
          title = 'Preview',
          title_pos = 'center',
          position = { 0, -2 },
          size = { width = 0.3, height = 0.3 },
          zindex = 200,
        },
      },
    },
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>ttd',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = '[d]iagnostics (Trouble)',
    },
    {
      '<leader>ttb',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = '[b]uffer Diagnostics (Trouble)',
    },
    {
      '<leader>tts',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = '[s]ymbols (Trouble)',
    },
    {
      '<leader>ttl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = '[l]sp Definitions / references / ... (Trouble)',
    },
    {
      '<leader>ttL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = '[L]ocation List (Trouble)',
    },
    {
      '<leader>ttq',
      '<cmd>Trouble qflist toggle<cr>',
      desc = '[q]uickfix List (Trouble)',
    },
  },
}
