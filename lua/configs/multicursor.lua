local mc = require "multicursor-nvim"

mc.setup()

local map = vim.keymap.set

-- Add cursors above or below the main cursor.
map({ "n", "x" }, "<leader>m<Up>", function()
  mc.lineAddCursor(-1)
end, { desc = "multicursor add cursor above" })

map({ "n", "x" }, "<leader>m<Down>", function()
  mc.lineAddCursor(1)
end, { desc = "multicursor add cursor below" })

-- Add or skip matches of the word/selection under the cursor.
map({ "n", "x" }, "<leader>mn", function()
  mc.matchAddCursor(1)
end, { desc = "multicursor add next match" })

map({ "n", "x" }, "<leader>mN", function()
  mc.matchAddCursor(-1)
end, { desc = "multicursor add previous match" })

map({ "n", "x" }, "<leader>ms", function()
  mc.matchSkipCursor(1)
end, { desc = "multicursor skip next match" })

map({ "n", "x" }, "<leader>mS", function()
  mc.matchSkipCursor(-1)
end, { desc = "multicursor skip previous match" })

map({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "multicursor add all matches" })

-- Cursor management.
map({ "n", "x" }, "<leader>m<Left>", mc.prevCursor, { desc = "multicursor previous cursor" })
map({ "n", "x" }, "<leader>m<Right>", mc.nextCursor, { desc = "multicursor next cursor" })
map({ "n", "x" }, "<leader>mq", mc.toggleCursor, { desc = "multicursor toggle cursor" })
map({ "n", "x" }, "<leader>mx", mc.deleteCursor, { desc = "multicursor delete cursor" })
map({ "n", "x" }, "<leader>mc", mc.clearCursors, { desc = "multicursor clear cursors" })

-- Add cursors with Ctrl + left mouse.
map("n", "<C-leftmouse>", mc.handleMouse, { desc = "multicursor add cursor with mouse" })
map("n", "<C-leftdrag>", mc.handleMouseDrag, { desc = "multicursor add cursors by dragging" })
map("n", "<C-leftrelease>", mc.handleMouseRelease, { desc = "multicursor finish mouse selection" })

-- These mappings only apply while multiple cursors are active.
mc.addKeymapLayer(function(layerSet)
  layerSet({ "n", "x" }, "<Esc>", function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end, { desc = "multicursor clear cursors" })
end)
