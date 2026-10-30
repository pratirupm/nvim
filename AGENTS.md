# AGENTS.md

Personal NvChad v2.5 user config. NvChad itself is an external lazy.nvim plugin; edit this repo, never files under `~/.local/share/nvim/lazy/` (they are regenerated/replaced).

## Where things go

- `init.lua` is load-order sensitive: set `base46_cache` and leader (space), bootstrap lazy.nvim, load NvChad, load theme caches, then `options`/`autocmds`/`mappings`. Do not reorder.
- `lua/chadrc.lua` must keep the structure of `NvChad/ui`'s `nvconfig.lua`; current theme is `kanagawa-dragon`. NvChad is pinned to `v2.5`, `ui`/`base46` to `v3.0`.
- `lua/plugins/init.lua` holds lazy.nvim specs; additional `lua/plugins/*.lua` files are auto-imported. NvChad already provides conform, lspconfig, telescope, nvim-tree, cmp, etc. — override those specs with `opts`/`config` in a separate entry with the same plugin name instead of installing a second plugin.
- `lua/configs/*.lua` holds per-plugin config returned from specs (for example `opts = function() return require "configs.conform" end`). `lua/configs/nvimtree.lua` extends NvChad's defaults to place nvim-tree on the right and close it after opening a file; `lua/configs/tabufline.lua` patches NvChad's buffer tabs to omit per-buffer close buttons; the tabufline override in `chadrc` removes the theme toggle and tree offset.
- `lua/options.lua`, `lua/mappings.lua`, and `lua/autocmds.lua` first load NvChad defaults; add custom settings/maps after those `require` calls or they can be overwritten.
- `lua/configs/lspconfig.lua` uses native Neovim LSP: add servers to `vim.lsp.enable { ... }`, not `require("lspconfig").server.setup()`. NvChad enables `lua_ls` separately.
- `lua/plugins/mason.lua` is the declarative Mason install list. It loads on `VeryLazy` and exposes the `MasonTools*` commands; add new editor tools there so a fresh clone provisions them automatically.
- `lua/plugins/go.lua` provides Gopher (`ft = "go"`), plus Neotest and DAP, which lazy-load on their keymaps/commands. `lua/configs/neotest.lua` and `lua/configs/dap.lua` contain their setup and keymaps; opening a Go file only loads Gopher. Gopher's optional `json2go` helper is not in the Mason registry; install it separately if `:GoJson` is needed.
- `lua/plugins/multicursor.lua` and `lua/configs/multicursor.lua` add multiple cursors with mappings under `<leader>m`; `<leader>ma` remains Telescope marks. The plugin lazy-loads on its first key.
- `lua/plugins/workflow.lua` adds lazygit, Trouble, grug-far, and nvim-surround. Git uses `<leader>gg`/`<leader>gf`, diagnostics `<leader>dd`, quickfix `<leader>dq`, and project replace `<leader>sr`. Visual `ms`/`mr`/`md` are Helix-style surround aliases; normal `ms`/`mr`/`md` remain mark commands. `mr`/`md` use `<C-\><C-n>` so multicursor's active `<Esc>` layer does not intercept them. `lua/mappings.lua` maps `miw`/`maw` and `miW`/`maW` to visual word selections for the same flow.
- `lua/plugins/navigation.lua` adds `nvim-ufo` folds and Helix-style `nvim-treesitter-textobjects` motions (`]f`/`[f`, `]t`/`[t`, `]a`/`[a`, `]c`/`[c`). `]c`/`[c` preserve the built-in diff-mode change motions. Telescope symbol/reference pickers were removed. Visual `S` remains `nvim-surround`, alongside the `ms` alias. `K` peeks folds before falling back to LSP hover.
- `lua/autocmds.lua` enforces 4-column local indentation after filetype plugins, soft-wraps prose filetypes, and highlights yanked text after NvChad's autocommands. `lua/options.lua` sets the global 80-column guide, 4-wide tabs/spaces, relative numbers, `cursorlineopt=both`, whitespace markers, unwrapped code, command-line/scroll defaults, disabled swap files, and persistent undo.
- `lua/configs/treesitter.lua` installs parsers on demand from the `FileType` event; `lua/plugins/treesitter.lua` registers that hook. Do not switch this to `install("all")` without discussing the time/disk cost.
- `lua/configs/conform.lua` formats Go on save with `goimports` followed by `golines --max-len=80` (Mason's `golines` is the golangci fork); Lua format-on-save remains disabled. `:ConformInfo` lazy-loads conform.
- `lazy-lock.json` is committed and generated; do not hand-edit it.

## Prerequisites

Mason cannot install the Go SDK, Neovim, a C compiler, or Node.js/npm. A fresh machine needs:

- Go toolchain installed before the first Neovim launch
- Neovim 0.12+ (`nvim-treesitter` is on `main`)
- A C compiler, `git`, `curl`, and `tar`
- Node.js and `npm` (Mason installs the HTML/CSS language servers from npm)
- `ripgrep` and `fd` for Telescope
- `lazygit` (optional, for the `<leader>gg` Git UI)

On first launch, lazy.nvim installs plugins and `mason-tool-installer` installs missing Mason tools. NvChad's eager `TSInstallAll` build is disabled; parsers that are not bundled with Neovim (for example Go) install when a file of that language is first opened.

Mason provides its own `gopls` and `delve` binaries; because Mason's `bin` directory is prepended to `PATH`, they take precedence over copies in `~/.local/bin`. Remove those entries from `lua/plugins/mason.lua` if the external versions are preferred.

## Commands

- Verify config loads: `nvim --headless "+qa"`.
- Install missing plugins: `nvim --headless "+Lazy! install" +qa`.
- Install missing Mason tools: launch Neovim and wait for the startup installer, or run `:MasonToolsInstallSync` in a normal session. The first launch installs them automatically after a short delay.
- Restore locked versions: `nvim --headless "+Lazy! restore" +qa`.
- Do not use `:Lazy sync` or `:Lazy update` for routine checks; both update plugins and rewrite `lazy-lock.json`.
- Format Lua: `stylua .` (requires `stylua` on `PATH`). Use `<leader>fm` or stylua manually; save does not format Lua.
- Test keymaps: `<leader>tr` nearest, `<leader>tf` file, `<leader>ts` summary, `<leader>to` output, `<leader>td` debug; the first use lazy-loads Neotest.
- DAP keymaps: `<F5>` continue, `<F10>` over, `<F11>` into, `<F12>` out, `<leader>db` breakpoint, `<leader>du` DAP UI; the first use lazy-loads nvim-dap and dap-ui.
- Check Go tooling: `:LspInfo`, `:Mason`, and `:checkhealth gopher`.
- There are no tests, build, lint, or CI workflows in this repo.

## Style

- Follow `.stylua.toml`: 2-space indent, 120 columns, double quotes, no call parentheses (`require "foo"`, unless chaining).
