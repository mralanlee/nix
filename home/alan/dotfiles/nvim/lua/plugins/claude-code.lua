return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      refresh = {
        enable = true,
        updatetime = 50,
        timer_interval = 1000,
        show_notifications = true,
      },
      git = {
        use_git_root = true,
      },
      keymaps = {
        window_navigation = true,
        scrolling = true,
      }
    })
  end
}
