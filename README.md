# Personal Neovim config

A personal NvChad v2.5 setup focused on Go and Lua editing, Helix-style navigation and surround, multiple cursors, and DAP/Neotest. NvChad is loaded as a lazy.nvim plugin; this repository contains the user overrides and additions.

# Fresh machine

Mason cannot install the Go SDK, Neovim, a C compiler, or Node.js/npm. Install these system prerequisites first:

- Go toolchain
- Neovim 0.12 or newer
- A C compiler, `git`, and `curl`
- `unzip`, `gzip`, and `tar` (GNU tar on Linux)
- Node.js and `npm` for the Mason-installed HTML/CSS language servers
- `ripgrep` and `fd` for Telescope
- `lazygit` (optional, for the `<leader>gg` Git UI)
- Windows only: PowerShell and 7-Zip for Mason's archive extraction

## Linux

### Debian / Ubuntu

```sh
sudo apt update
sudo apt install -y build-essential git curl unzip gzip tar nodejs npm ripgrep fd-find golang-go neovim
# Debian/Ubuntu install the fd binary as fdfind.
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
```

### Fedora

```sh
sudo dnf install -y gcc make git curl unzip gzip tar nodejs npm ripgrep fd-find golang neovim
```

### Fedora Silverblue

Silverblue is immutable, so install packages into the base image with `rpm-ostree` and reboot:

```sh
sudo rpm-ostree install gcc make git curl unzip gzip tar nodejs npm ripgrep fd-find golang neovim
systemctl reboot
```

Alternatively, install Linuxbrew below; it avoids layering packages but still needs the system compiler, `make`, Git, curl, unzip, and tar.

### Arch Linux

```sh
sudo pacman -S --needed base-devel git curl unzip gzip tar nodejs npm ripgrep fd go neovim lazygit
```

On other distributions, install the equivalent packages; Linuxbrew below is a fallback.

### Linuxbrew (any distribution)

Install Homebrew, then the tools:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install go neovim node ripgrep fd lazygit
```

Linuxbrew uses the host compiler; install `gcc`, `make`, `git`, `curl`, `unzip`, and `tar` with your distribution first. Add the `brew shellenv` line to your shell profile if it is not already there.

`lazygit` is optional; install it where your package manager provides it.

## macOS

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install go neovim node ripgrep fd lazygit
```

The Xcode command-line tools provide the compiler and `make`; macOS already includes Git, curl, tar, unzip, and gzip.

## Windows

In PowerShell, install the native tools with `winget`:

```powershell
winget install --id Git.Git -e
winget install --id GoLang.Go -e
winget install --id Neovim.Neovim -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id BurntSushi.ripgrep.MSVC -e
winget install --id sharkdp.fd -e
winget install --id 7zip.7zip -e
winget install --id JesseDuffield.lazygit -e
winget install --id Microsoft.VisualStudio.2022.BuildTools -e
```

In the Build Tools installer, select **Desktop development with C++**. Native Windows uses `%LOCALAPPDATA%\nvim` for Neovim's config.

For WSL2, run `wsl --install -d Ubuntu` from PowerShell, then follow the Debian/Ubuntu steps inside WSL.

Before cloning, open a new terminal and check `nvim --version` (0.12+) and `go version`; use Linuxbrew or the upstream releases if either is too old.

## Clone the config

Linux, macOS, and WSL2:

```sh
mkdir -p ~/.config
git clone https://github.com/pratirupm/nvim.git ~/.config/nvim
nvim
```

Windows PowerShell:

```powershell
git clone https://github.com/pratirupm/nvim.git "$env:LOCALAPPDATA\nvim"
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
| `u` / `<C-r>` / `U` | Undo / redo / redo (normal mode) |
| `ys` / `cs` / `ds` / visual `S` | Add/change/delete surrounding characters |
| `miw` / `maw` | Select inside/around word |
| `miW` / `maW` | Select inside/around WORD |
| `ms"` / `mr"'` / `md"` | Helix-style add/change/delete surround (visual mode) |

The `ms` / `mr` / `md` aliases work in visual mode, so select first with `miw` and then use `ms"`, `mr"'`, or `md"`; repeat the selection before changing or deleting. Pressing `m` in visual mode shows those choices in which-key. Normal-mode `ms` / `mr` / `md` remain mark commands; use `ys` / `cs` / `ds` without selecting first.

Yanked text is briefly highlighted. `scrolloff` and `sidescrolloff` are set to 8, `confirm` is enabled, floating windows use rounded borders, swap files are disabled, and undo history is persistent. The file explorer sits on the right and closes after opening a file. Buffer tabs omit per-buffer close buttons and the tabline has no close-all button; use `<leader>x` to close the current buffer.

Go buffers format on save with `goimports` followed by `golines --max-len=80`. Lua format-on-save is disabled; `:ConformInfo` shows the available formatters.

# Terminal

| Keys | Action |
| --- | --- |
| `<leader>tt` | Toggle the bottom terminal |
| `<C-t>` | Toggle the bottom terminal from terminal mode |
| `<Esc><Esc>` / `<C-x>` | Return to normal mode from terminal mode |
| `<leader>pt` | Pick a hidden terminal buffer |

There is one persistent bottom terminal. Closing and reopening it reuses the same buffer and shell; if it is the last window, it is replaced by the alternate buffer instead of closing Neovim. If it is visible in another tab, `<leader>tt` focuses that tab instead of opening a duplicate. Exit the shell to start a fresh one on the next toggle.

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

Folds use `nvim-ufo` with Treesitter and indentation fallbacks. All folds start open (`foldlevel=99`), and the fold column shows open/closed markers. A folded block keeps its closing bracket visible at the end of the folded line, for example `func main() { ⋯ }`. A wrapped signature is joined onto the folded function line, for example `func New(title string) Task { ⋯ }`.

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
