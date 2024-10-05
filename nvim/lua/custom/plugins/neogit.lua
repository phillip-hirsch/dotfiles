return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "echasnovski/mini.pick",         -- optional
    },
    config = true,
    opt = {
      -- Change the default way of opening neogit
      kind = 'tab',
      -- Change the default way of opening the commit popup
      commit_popup = {
        kind = 'split',
      },
      -- Change the default way of opening popups
      popup = {
        kind = 'split',
      },
    },
  },
}
