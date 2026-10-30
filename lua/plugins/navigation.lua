return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      require("ufo").setup(opts)

      local ufo = require "ufo"
      local map = vim.keymap.set

      map("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
      map("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
      map("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds except kinds" })
      map("n", "zm", ufo.closeFoldsWith, { desc = "Close folds with kind" })
      map("n", "K", function()
        if not ufo.peekFoldedLinesUnderCursor() then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold or LSP hover" })
    end,
  },

  -- Helix-style motions; keep the built-in diff-mode `]c`/`[c` behavior.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup {
        move = { set_jumps = true },
      }

      local map = vim.keymap.set
      local modes = { "n", "x", "o" }
      local move = require "nvim-treesitter-textobjects.move"

      local function has_parser()
        local ok, parser = pcall(vim.treesitter.get_parser, 0, nil, { error = false })
        return ok and parser ~= nil
      end

      local function jump(method, capture)
        return function()
          if has_parser() then
            move[method](capture, "textobjects")
          end
        end
      end

      local function jump_comment(method, fallback)
        return function()
          if vim.wo.diff and vim.api.nvim_get_mode().mode == "n" then
            vim.cmd(("normal! %d%s"):format(vim.v.count1, fallback))
          elseif has_parser() then
            move[method]("@comment.outer", "textobjects")
          end
        end
      end

      map(modes, "]f", jump("goto_next_start", "@function.outer"), { desc = "Next function" })
      map(modes, "[f", jump("goto_previous_start", "@function.outer"), { desc = "Previous function" })
      map(modes, "]t", jump("goto_next_start", "@class.outer"), { desc = "Next type" })
      map(modes, "[t", jump("goto_previous_start", "@class.outer"), { desc = "Previous type" })
      map(modes, "]a", jump("goto_next_start", "@parameter.inner"), { desc = "Next parameter" })
      map(modes, "[a", jump("goto_previous_start", "@parameter.inner"), { desc = "Previous parameter" })
      map(modes, "]c", jump_comment("goto_next_start", "]c"), { desc = "Next comment" })
      map(modes, "[c", jump_comment("goto_previous_start", "[c"), { desc = "Previous comment" })
    end,
  },
}
