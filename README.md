# Personal Neovim config

A personal NvChad v2.5 setup focused on Go and Lua editing, Helix-style navigation and surround, multiple cursors, and DAP/Neotest. NvChad is loaded as a lazy.nvim plugin; this repository contains the user overrides and additions.

# Fresh machine

Mason cannot install the Go SDK, Neovim, a C compiler, or Node.js/npm. Install these system prerequisites first:

- Go toolchain
- Neovim 0.12 or newer
- A C compiler, `git`, `curl`, and `tar`
- Node.js and `npm` for the Mason-installed HTML/CSS language servers
- `ripgrep` and `fd` for Telescope
- `lazygit` (optional, for the `<leader>gg` Git UI)

Then clone this config and launch Neovim once:

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

The first launch installs lazy.nvim plugins, then the missing Mason tools after a short delay. Tree-sitter parsers that are not bundled with Neovim, including Go, are installed the first time a file of that language is opened. If a Go buffer was opened while Mason was still installing the language servers, they are attached again automatically once Mason finishes.

For a non-interactive plugin bootstrap:

```sh
nvim --headless "+Lazy! install" +qa
```

Then launch Neovim normally once and let Mason finish, or run `:MasonToolsInstallSync` from that session.

# Workflow

| Keys | Action |
| --- | --- |
| `<leader>gg` | Open lazygit |
| `<leader>gf` | Open lazygit for the current file |
| `<leader>dd` | Toggle the diagnostics panel |
| `<leader>dq` | Toggle the quickfix panel |
| `<leader>sr` | Search and replace across the project |
| `ys` / `cs` / `ds` / visual `S` | Add/change/delete surrounding characters |
| `miw` / `maw` | Select inside/around word |
| `miW` / `maW` | Select inside/around WORD |
| `ms"` / `mr"'` / `md"` | Helix-style add/change/delete surround (visual mode) |

The `ms` / `mr` / `md` aliases work in visual mode, so select first with `miw` and then use `ms"`, `mr"'`, or `md"`; repeat the selection before changing or deleting. Normal-mode `ms` / `mr` / `md` remain mark commands; use `ys` / `cs` / `ds` without selecting first.

Yanked text is briefly highlighted. `scrolloff` and `sidescrolloff` are set to 8, `confirm` is enabled, floating windows use rounded borders, swap files are disabled, and undo history is persistent. The file explorer sits on the right and closes after opening a file. Buffer tabs omit per-buffer close buttons and the tabline has no close-all button; use `<leader>x` to close the current buffer.

Go buffers format on save with `goimports` followed by `golines --max-len=80`. Lua format-on-save is disabled; `:ConformInfo` shows the available formatters.

# Display and indentation

- Every buffer has an 80-column guide (`colorcolumn=80`).
- Tabs are 4 columns wide everywhere. `expandtab` is on by default, so indentation uses 4 spaces; filetypes that require hard tabs, such as Go and Make, keep tabs at a 4-column width.
- Relative line numbers are enabled.
- `cursorlineopt=both` makes `cursorline` highlight both the current line and its line number. The other useful values are `line` (line only) and `number` (number column only).
- Whitespace is visible: tabs show as `» `, trailing spaces as `·`, and non-breaking spaces as `␣`.
- Code does not wrap. Markdown, plain text, git commit messages, and AsciiDoc soft-wrap.
- Live substitution previews (`inccommand=split`), case-insensitive command-line completion, `shiftround`, capped completion popups, and smoother scrolling/jumps are enabled.

# Code navigation and folds

Tree-sitter textobjects provide Helix-style motions between code structures.

| Keys | Action |
| --- | --- |
| `]f` / `[f` | Next/previous function |
| `]t` / `[t` | Next/previous type/class |
| `]a` / `[a` | Next/previous parameter/argument |
| `]c` / `[c` | Next/previous comment |
| `zR` / `zM` | Open/close all folds |
| `zr` / `zm` | Open folds except kinds / close folds by kind |
| `za` | Toggle the fold under the cursor |
| `K` | Peek folded lines, otherwise LSP hover |

Counts work (`3]f`), and jumps are added to the jumplist. `]c` / `[c` keep the built-in diff-mode change motions. `gf` remains available for the built-in file-under-cursor jump.

Folds use `nvim-ufo` with Treesitter and indentation fallbacks. All folds start open (`foldlevel=99`), and the fold column shows open/closed markers.

# Tests and debugging

DAP and Neotest load on first use, so opening a Go file does not start the debugger UI or test adapter.

| Keys | Action |
| --- | --- |
| `<leader>tr` | Run the nearest Go test |
| `<leader>tf` | Run the current Go test file |
| `<leader>ts` | Toggle the test summary |
| `<leader>to` | Open test output |
| `<leader>td` | Debug the nearest Go test |
| `<F5>` | Continue |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out |
| `<leader>db` | Toggle a breakpoint |
| `<leader>du` | Toggle the DAP UI |

`:Neotest` and the `:Dap*` commands are also available and load their plugins on demand.

# Multiple cursors

`multicursor.nvim` lazy-loads on its first key. Leader is Space; `<leader>ma` remains Telescope marks.

| Keys | Action |
| --- | --- |
| `<leader>m<Up>` / `<leader>m<Down>` | Add a cursor above/below |
| `<leader>mn` / `<leader>mN` | Add the next/previous match |
| `<leader>ms` / `<leader>mS` | Skip the next/previous match |
| `<leader>mA` | Add all matches |
| `<leader>m<Left>` / `<leader>m<Right>` | Switch the active cursor |
| `<leader>mq` | Toggle a cursor at the current position |
| `<leader>mx` | Remove the active cursor |
| `<leader>mc` | Clear all cursors |
| `<Esc>` | Clear cursors while active, or re-enable disabled cursors |
| `Ctrl+left mouse` | Add cursors with the mouse |

Insert, delete, and visual-mode changes apply to every active cursor.

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
