# AGENTS.md

Personal NvChad v2.5 config. NvChad is an external lazy.nvim plugin: edit this repo, never `~/.local/share/nvim/lazy/` (regenerated/replaced).

## Layout and load order

- `init.lua` is load-order sensitive: set `base46_cache` and leader (Space), bootstrap lazy.nvim, load NvChad, load theme caches, then `options`/`autocmds`/`mappings`. Do not reorder.
- `lua/chadrc.lua` must match `NvChad/ui`'s `nvconfig.lua` shape. Theme is `kanagawa-dragon`; NvChad is pinned to v2.5, `ui`/`base46` to v3.0.
- `lua/plugins/init.lua` holds specs; `lua/plugins/*.lua` files auto-import. NvChad already supplies conform, lspconfig, telescope, nvim-tree, cmp, etc. Override them with `opts`/`config` in a same-name spec; do not add duplicate plugins.
- `lua/configs/*.lua` holds setup/config modules. Most are wired from plugin specs; `tabufline.lua` is called from `chadrc`. `nvimtree.lua` puts the tree on the right and closes it after opening; `tabufline.lua` removes per-buffer close buttons. `chadrc` removes the tabline theme toggle, close-all button, and tree offset.
- `lua/options.lua`, `lua/mappings.lua`, and `lua/autocmds.lua` load NvChad defaults first; add custom settings/maps after those `require`s or they can be overwritten. The FileType autocmds enforce 4-column indentation after filetype plugins and soft-wrap prose.
- `lua/configs/lspconfig.lua` uses native LSP: add servers to `vim.lsp.enable { ... }`, not `require("lspconfig").server.setup()`. NvChad enables `lua_ls` separately.

## Lazy loading and gotchas

- `lua/plugins/mason.lua` is the declarative Mason install list. It loads on `VeryLazy`; `MasonTools*` commands are available immediately. Add new editor tools there so fresh clones provision them.
- `lua/plugins/go.lua` keeps Gopher on `ft = "go"`; Neotest and DAP lazy-load on keymaps/commands. `configs/neotest.lua` and `configs/dap.lua` contain setup/keymaps. Opening a Go file loads Gopher but not Neotest/DAP. Gopher's optional `json2go` helper is not in the Mason registry; install it separately for `:GoJson`.
- `lua/plugins/multicursor.lua` lazy-loads on its first `<leader>m` key; `configs/multicursor.lua` holds the mappings, and `<leader>ma` remains Telescope marks.
- `lua/plugins/workflow.lua` adds lazygit, Trouble, grug-far, and nvim-surround. Visual `ms`/`mr`/`md` are Helix aliases; normal `ms`/`mr`/`md` remain marks. Visual `S` remains the nvim-surround add alias. `mr`/`md` use `<C-\><C-n>` so multicursor's `<Esc>` layer does not intercept them; `lua/mappings.lua` maps `miw`/`maw`/`miW`/`maW` to visual word selections for the same flow.
- `lua/plugins/navigation.lua` adds nvim-ufo and TSO motions; `]c`/`[c` preserve diff-mode change motions. `K` peeks folds then falls back to LSP hover. Telescope symbol/reference pickers were removed.
- `lua/configs/treesitter.lua` installs parsers on demand from `FileType`; `lua/plugins/treesitter.lua` disables NvChad's eager `TSInstallAll`. Do not switch to `install("all")` without discussing time/disk.
- `lua/configs/conform.lua` formats Go on save with `goimports` then `golines --max-len=80` (Mason's `golines` is the golangci fork); Lua format-on-save is off. `:ConformInfo` lazy-loads conform.
- `lazy-lock.json` is generated and committed; do not hand-edit it.

## Prerequisites

Mason cannot install Go, Neovim, a C compiler, or Node/npm. A fresh machine needs:

- Go toolchain before the first Neovim launch
- Neovim 0.12+ (`nvim-treesitter` is on `main`)
- C compiler, `git`, `curl`, `tar`
- Node.js/npm for Mason's HTML/CSS servers
- `ripgrep`/`fd` for Telescope
- `lazygit` optional for `<leader>gg`

First launch installs lazy.nvim plugins and Mason tools after a delay. Parsers not bundled with Neovim (e.g. Go) install when a file of that language opens. Mason's `gopls`/`delve` take precedence over `~/.local/bin` because Mason's bin is prepended to `PATH`; remove them from `lua/plugins/mason.lua` to use external copies.

## Commands

- Load check: `nvim --headless "+qa"`
- Format check: `stylua --check .` (`stylua .` fixes; requires `stylua` on `PATH`)
- Install plugins: `nvim --headless "+Lazy! install" +qa`
- Install Mason tools: `:MasonToolsInstallSync` in a normal session (first launch also does it after a delay)
- Restore lockfile: `nvim --headless "+Lazy! restore" +qa`
- Do not use `:Lazy sync` or `:Lazy update` for routine checks; both update plugins and rewrite `lazy-lock.json`.
- No test suite, build, or CI. Verify with the load/format checks above.
- Test/DAP keys: `<leader>tr`/`tf`/`ts`/`to`/`td`; `<F5>`/`F10`/`F11`/`F12`; `<leader>db`/`du`. First use lazy-loads Neotest/DAP.
- Go tooling: `:LspInfo`, `:Mason`, `:checkhealth gopher`.

## Style

- Follow `.stylua.toml`: 2 spaces, 120 columns, double quotes, no call parentheses (`require "foo"` unless chaining).
- `README.md` documents user-facing keymaps/UI behavior; update it when they change.
