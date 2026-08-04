# dotfiles

Personal config for macOS — Neovim, Ghostty, Starship, and a few other tools.

## Requirements

- macOS (primary target)
- [Neovim](https://neovim.io/) ≥ 0.10
- [Ghostty](https://ghostty.org/) terminal
- [BerkeleyMono Nerd Font](https://www.nerdfonts.com/) (or swap in any Nerd Font)
- `git`, `ripgrep`, `fd` — used by Telescope
- Language runtimes as needed (Node, Python, Java) — Mason handles the LSP servers

## Installation

```sh
git clone https://github.com/jk-esc/.config.git ~/.config
```

Open Neovim — lazy.nvim bootstraps itself and installs all plugins on first launch. Mason will prompt you to install LSP servers as needed (or run `:MasonInstall` manually).

---

## Tools

| Tool | Purpose |
|------|---------|
| **Neovim** | Editor. v0.12, lazy.nvim plugin manager |
| **Ghostty** | Terminal emulator with custom GLSL shader |
| **Starship** | Shell prompt |
| **Fastfetch** | System info on shell start |
| **Btop** | Resource monitor |

---

## Neovim

### Plugins

| Category | Plugin |
|----------|--------|
| LSP | nvim-lspconfig, Mason, nvim-jdtls (Java) |
| Completion | blink.cmp |
| Fuzzy finding | Telescope |
| File tree | nvim-tree |
| Git | gitsigns |
| Formatting | conform.nvim |
| Linting | nvim-lint |
| Debugging | nvim-dap |
| Syntax | nvim-treesitter |
| Diagnostics | trouble.nvim |
| UI | bufferline, lualine, alpha, dressing, indent-blankline |
| Sessions | auto-session |

### Keybinds

`<leader>` is `Space`.

**General**

| Key | Action |
|-----|--------|
| `jk` | Exit insert mode |
| `<leader>nh` | Clear search highlights |
| `+` / `-` | Increment / decrement number |
| `<leader>p/P` | Paste from yank register (ignores the clipboard clobber) |
| `<leader>d/D/c/C` | Delete / change without touching registers |

**Windows & tabs**

| Key | Action |
|-----|--------|
| `<leader>sv/sh` | Split vertical / horizontal |
| `<leader>se` | Equalise split sizes |
| `<leader>sx` | Close split |
| `<leader>sm` | Toggle maximise current split |
| `<leader>to/tx/tn/tp` | Tab: open / close / next / previous |

**File tree & search**

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle nvim-tree |
| `<leader>ff` | Find files |
| `<leader>fs` | Live grep |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | List open buffers |

**LSP**

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gR` | Show references |
| `gt` | Show type definition |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>d` | Line diagnostics |
| `<leader>D` | File diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>rs` | Restart LSP |

**Git (gitsigns)**

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs/hr` | Stage / reset hunk |
| `<leader>hS/hR` | Stage / reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this |

**Telescope git**

| Key | Action |
|-----|--------|
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>gs` | Git status |

**Diagnostics (trouble.nvim)**

| Key | Action |
|-----|--------|
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xt` | Todo list |
| `<leader>xq` | Quickfix list |

---

## Ghostty

Theme: Gruvbox Dark. Custom GLSL shader in `ghostty/shaders/`.

| Key | Action |
|-----|--------|
| `opt+h/j/k/l` | Navigate splits |
| `opt+shift+h/j/k/l` | Create split left / down / up / right |
