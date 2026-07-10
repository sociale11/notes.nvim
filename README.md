# notes.nvim

A simple, opinionated daily note plugin for Neovim.

## Why?

You want to keep a daily Markdown journal per project. Opening a new file by
hand, naming it with today's date, storing it somewhere sane — it gets old
fast.

Popular options:
- **Obsidian** powerful, but not Neovim-native and adds friction
- **vimwiki** dated, markdown support is bolted on
- **manual** `:e ~/notes/proj/2026-07-10.md` every time

notes.nvim gives you one keybind to open today's note alongside a file browser
for your project's notes directory.

## How it works

`<leader>nn` or `:DailyNote` from any file in your project:

1. Resolves the project root (git root or cwd)
2. Creates `~/notes/<project>/` if needed
3. Opens `~/notes/<project>/YYYY-MM-DD.md` (auto-inserts a header if new)
4. Opens a Neo-tree panel on the right rooted at your notes directory

Notes are organized per project. A `.root` marker file inside each notes
directory tracks which source directory it belongs to. If two projects share a
name but live under different parents, the plugin appends the parent name to
avoid collisions.

## Install

With lazy.nvim:

```lua
{
  "sociale11/notes.nvim",
  dependencies = { "nvim-neo-tree/neo-tree.nvim" },
  config = true,
}
```

With any other plugin manager — add `sociale11/notes.nvim` and call
`require("dailynote").setup()`.

## Quick start

```lua
require("dailynote").setup()
```

```vim
" Or skip setup and just use the command
:DailyNote
```

That's it. No config options. Press `<leader>nn` from anywhere in a git repo.

## Commands

| Command | Description |
|---------|-------------|
| `<leader>nn` | Toggle daily note panel |
| `:DailyNote` | Same as above |

## Design decisions

**Per-project isolation.** Notes live under `~/notes/<project>/`. If you switch
projects, so does your note context. No cross-project clutter.

**Git root as project boundary.** The plugin uses `git rev-parse --show-toplevel`
to determine the project. No config file, no assumptions about directory
structure. If you're not in a git repo, it uses cwd as-is.

**Neo-tree, not a custom browser.** Rather than building a notes sidebar from
scratch, notes.nvim opens Neo-tree with the notes directory as root. You get file
operations, search, and navigation for free.

**Marker-based conflict resolution.** A `.root` file stores the canonical
project path. On subsequent opens, if the marker points somewhere else, the
notes dir gets renamed with a parent suffix instead of silently overwriting or
erroring.

## Known tradeoffs

**Neo-tree dependency.** The plugin hard-fails with a notification if neo-tree
isn't installed. No fallback to netrw or other explorers.

**One daily file per project.** No weekly/monthly views, no backlinks, no search
index. This is a minimal daily journal, not a knowledge base.

**No config.** There's no `setup()` options. If you want a different notes root,
different keybind, or different date format, you'd fork or wrap it.

## Project structure

```
notes.nvim/
├── lua/
│   └── dailynote/
│       ├── init.lua       # setup() and toggle()
│       ├── daily.lua      # daily note file ops
│       └── project.lua    # project resolution and notes dir management
└── README.md
```

## License

MIT
