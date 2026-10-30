local neotest = require "neotest"
local map = vim.keymap.set

neotest.setup {
  adapters = {
    require "neotest-golang" {
      runner = "gotestsum",
      dap_mode = "dap-go",
    },
  },
}

map("n", "<leader>tr", neotest.run.run, { desc = "Run nearest Go test" })
map("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand "%")
end, { desc = "Run Go test file" })
map("n", "<leader>ts", neotest.summary.toggle, { desc = "Toggle test summary" })
map("n", "<leader>to", function()
  neotest.output.open { enter = true }
end, { desc = "Open test output" })
map("n", "<leader>td", function()
  neotest.run.run { strategy = "dap" }
end, { desc = "Debug nearest Go test" })
