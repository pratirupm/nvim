# AGENTS.md

Personal NvChad v2.5 config for Go/Lua editing. NvChad is an external lazy.nvim plugin: edit this repo, never `~/.local/share/nvim/lazy/` (regenerated/replaced).

## Layout and load order

- `init.lua`: set `base46_cache` and leader first, prepend lazy.nvim, `lazy.setup` (NvChad then `plugins`), load the `defaults`/`statusline` base46 caches, then `options`/`autocmds`; `mappings` is deferred with `vim.schedule`. Do not reorder, and do not expect mappings to exist during startup.
- `lua/chadrc.lua` must match `NvChad/ui` v3.0's `nvconfig.lua`; theme is `kanagawa-dragon`; NvChad is pinned to v2.5, `ui`/`base46` to v3.0. Its tabufline `order` drops the theme toggle, close-all button, and tree offset; `configs/tabufline.lua` drops per-buffer close icons.
- `lua/plugins/init.lua` and auto-imported `lua/plugins/*.lua` hold specs. NvChad already supplies conform, lspconfig, telescope, nvim-tree, cmp, etc.; override in a same-name spec with `opts`/`config`, never add a duplicate plugin.
- `lua/configs/*.lua` are setup modules wired from specs; `tabufline.lua` is called from `chadrc`, `terminal.lua` from `mappings`. `nvimtree.lua` puts the tree on the right and closes it after opening.
- `lua/options.lua`, `lua/mappings.lua`, and `lua/autocmds.lua` load NvChad defaults first; custom entries must come after. FileType autocmds force 4-column indentation and soft-wrap prose.
- LSP uses the native API: add servers to `vim.lsp.enable` in `configs/lspconfig.lua`, not `require("lspconfig").server.setup()`. NvChad enables `lua_ls` in its `defaults()`.

## Lazy loading and traps

- `plugins/mason.lua` is the declarative Mason install list (`run_on_start` after 3 s). Add editor tools there so fresh clones provision them. Mason cannot install Go, Neovim, a C compiler, or Node/npm.
- `plugins/go.lua` lazy-loads Gopher on `ft=go`, Neotest/DAP on commands/keys; opening Go loads Gopher only. Neotest uses `gotestsum` and `dap-go`.
- `plugins/multicursor.lua` lazy-loads on the first `<leader>m`; mappings live in `configs/multicursor.lua`, and `<leader>ma` remains Telescope marks.
- `plugins/workflow.lua`: visual `ms`/`mr`/`md` are Helix surround aliases; normal `ms`/`mr`/`md` remain marks and visual `S` remains nvim-surround add. `mr`/`md` use `<C-\><C-n>` so multicursor's `<Esc>` layer does not eat them. `mappings.lua` adds `miw`/`maw`/`miW`/`maW` visual selections.
- Visual-mode `m` needs the explicit which-key trigger `{ "m", mode = "x" }` in `plugins/init.lua`; auto-triggers skip single-letter prefixes other than `g`/`z`/`Z`. Keep that override a plain `opts` table: the equivalent `opts` function merged to `{}` under NvChad's spec.
- `plugins/navigation.lua` customizes nvim-ufo: `treesitter_folds` drops duplicate block folds and `fold_virt_text_handler` joins wrapped signatures. Keep `enable_get_fold_virt_text = true` and the provider function, or folded signatures break. `]c`/`[c` retain diff motions; `K` peeks folds then falls back to LSP hover.
- Treesitter parsers install on demand from `FileType`; `plugins/treesitter.lua` sets `build = false` to disable NvChad's `TSInstallAll`. Do not switch to `install "all"`. This needs the `tree-sitter` CLI (Mason installs it); pending installs retry after `MasonToolsUpdateCompleted`.
- `configs/conform.lua`: Go formats on save with `goimports` then `golines --max-len=80`; Lua is not formatted on save. `:ConformInfo` lazy-loads conform.
- `configs/terminal.lua` owns the single persistent bottom terminal (`nvchad.term`, id `mainTerm`, 30%): `<leader>tt` toggles, terminal-mode `<C-t>` toggles, and setup deletes NvChad's `<leader>h`/`<leader>v`/`<A-h>`/`<A-v>`/`<A-i>` maps. When it is the last window it swaps in the alternate buffer instead of closing Neovim (E444). If it is visible in another tab, toggle focuses it instead of creating a duplicate; do not add split/float terminals.
- `lazy-lock.json` is generated and committed; do not hand-edit it.

## Prerequisites

Full per-OS commands are in `README.md`. A fresh machine needs Neovim 0.12+, Go, a C compiler, `git`/`curl`/`unzip`/`gzip`/`tar`, Node/npm (Mason HTML/CSS servers), `ripgrep`/`fd`, and `stylua` for checks; `lazygit` is optional, and Windows also needs PowerShell and 7-Zip. Mason's bin is prepended to `PATH`, so its `gopls`/`delve` shadow `~/.local/bin`; remove them from `lua/plugins/mason.lua` to use external copies.

## Commands

- Load check: `nvim --headless "+qa" 2>&1`; exit status is 0 even for init errors, so read the output.
- Mapping/terminal check: `nvim --headless "+lua require('mappings')" +qa 2>&1`; `+lua` runs before the deferred `mappings`, so inspect the module explicitly.
- Format: `stylua --check .`; `stylua .` fixes.
- Install plugins: `nvim --headless "+Lazy! install" +qa`; restore lockfile: `nvim --headless "+Lazy! restore" +qa`.
- Install Mason tools: `:MasonToolsInstallSync` in a normal session (first launch also runs them after ~3 s).
- Do not use `:Lazy sync` or `:Lazy update` for routine checks; both update plugins and rewrite `lazy-lock.json`.
- No test suite, build, or CI. For keymap/which-key/terminal behavior use a real UI (`nvim --embed` + `uiAttach`, or a pty); headless `feedkeys` gave misleading results.
- Go tooling: `:LspInfo`, `:Mason`, `:checkhealth gopher`.

## Style

- Follow `.stylua.toml`: 2 spaces, 120 columns, double quotes, no call parentheses (`require "foo"` unless chaining).
- `README.md` documents user-facing keymaps and UI behavior plus per-OS installs; update it when behavior changes.
