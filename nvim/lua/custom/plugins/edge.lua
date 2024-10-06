return {
  {
    'sainnhe/edge',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.edge_style = 'aura'
      vim.g.edge_dim_foreground = 1
      vim.g.edge_better_performance = 1
      -- vim.g.edge_enable_italic = true
      vim.cmd.colorscheme 'edge'
    end,
  },
}
