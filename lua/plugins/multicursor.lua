return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      { "<leader>m<Up>", mode = { "n", "x" }, desc = "multicursor add cursor above" },
      { "<leader>m<Down>", mode = { "n", "x" }, desc = "multicursor add cursor below" },
      { "<leader>mn", mode = { "n", "x" }, desc = "multicursor add next match" },
      { "<leader>mN", mode = { "n", "x" }, desc = "multicursor add previous match" },
      { "<leader>ms", mode = { "n", "x" }, desc = "multicursor skip next match" },
      { "<leader>mS", mode = { "n", "x" }, desc = "multicursor skip previous match" },
      { "<leader>mA", mode = { "n", "x" }, desc = "multicursor add all matches" },
      { "<leader>m<Left>", mode = { "n", "x" }, desc = "multicursor previous cursor" },
      { "<leader>m<Right>", mode = { "n", "x" }, desc = "multicursor next cursor" },
      { "<leader>mq", mode = { "n", "x" }, desc = "multicursor toggle cursor" },
      { "<leader>mx", mode = { "n", "x" }, desc = "multicursor delete cursor" },
      { "<leader>mc", mode = { "n", "x" }, desc = "multicursor clear cursors" },
      { "<C-leftmouse>", desc = "multicursor add cursor with mouse" },
      { "<C-leftdrag>", desc = "multicursor add cursors by dragging" },
      { "<C-leftrelease>", desc = "multicursor finish mouse selection" },
    },
    config = function()
      require "configs.multicursor"
    end,
  },
}
