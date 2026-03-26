return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = table.concat({
          "My Custom",
          "Dashboard Header",
        }, "\n"),
      },
    },
  },
}
