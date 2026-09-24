# omarchy-dotfiles

My changes on top of a stock [Omarchy](https://omarchy.org) install. Only what differs from Omarchy's defaults lives here; everything else stays with Omarchy so `omarchy update` keeps working.

```bash
git clone https://github.com/cvtmal/omarchy-dotfiles.git ~/Work/omarchy-dotfiles
~/Work/omarchy-dotfiles/install.sh
```

| Script | What it does |
| --- | --- |
| `install.sh` | `link.sh`, then `packages.sh` |
| `link.sh` | Symlinks `home/` (and this machine's `hosts/*/home/`) into `$HOME` |
| `packages.sh` | Installs apps and themes Omarchy does not ship by default |
| `upgrade.sh` | Pulls this repo, re-runs `install.sh`, updates themes, runs `omarchy update` |

All scripts are safe to run again.

## What's in it

- **Keyboard**: Swiss German Mac layout (`ch`/`de_mac`), Caps Lock as compose, left Alt as AltGr, flat mouse accel, natural scrolling. See `home/.config/hypr/input.lua`.
- **Mac shortcuts** for the Swiss Mac layout in `home/.config/hypr/bindings.lua`:

  | Keys | Action |
  | --- | --- |
  | `Cmd + C` `V` `X` | Copy, paste, cut (Omarchy's universal clipboard) |
  | `Cmd + Z` `A` | Undo, select all |
  | `Cmd + T` `W` `L` `R` | New tab (new terminal in a terminal), close tab, address bar, reload |
  | `Cmd + Shift + ü` `¨` | Previous tab, next tab (the US `[` `]` keys) |
  | `Cmd + ←` `→` `↑` `↓` | Line start, line end, document start, document end |
  | `Option + ←` `→` | Word left, word right |
  | `Cmd + Backspace` | Delete to line start |
  | `Option + Backspace` | Delete word left |
  | `Cmd + Q` | Close window |

  The Omarchy actions these replace moved to `Cmd + Option`: `T` float/tile, `L` workspace layout, `Backspace` transparency, arrows to focus windows.
- **Terminals**: Ghostty as default; font size 8 in Ghostty, Alacritty and Kitty.
- **Bar**: transparent Omarchy shell bar (`home/.config/omarchy/shell.json`), UI font size 11 (`shell.toml`).
- **Git**: Omarchy's git defaults plus `gh` as GitHub credential helper.
- **Apps**: Brave (default browser), Sublime Text, Codex desktop, Voxtype dictation, and Claude as the default Omarchy agent.
- **mise**: `claude`, `codex`, `gh`, `node` in `home/.config/mise/config.toml`.
- **Themes**: eight community themes installed from git, starting on Japan Night. Edit the list at the top of `packages.sh`.

## Per-machine files

Files under `hosts/<name>/home/` override `home/` on one machine. `<name>` is the hostname, or failing that the hardware model from `/sys/class/dmi/id/product_name`, so a fresh install on the same hardware picks it up without renaming anything.

- `hosts/MacBook10,1/` — the 12" Retina MacBook: display scale 2.

## How edits flow

Linked files are symlinks into this repo, so editing `~/.config/...` edits the repo. Commit when happy.

Some apps save by writing a new file and renaming it over the old one, which replaces the symlink with a plain file. The Omarchy shell does this to `shell.json` when you change the bar from the UI. `link.sh` remembers what it linked; when one of those comes back as a plain file, it copies the change into the repo and re-links it. Check `git diff` after running it.

Files that existed before the first link are backed up to `~/.local/state/dotfiles/backup/`.

## Adding something

- A config file: move it to the same path under `home/` and run `./link.sh`.
- An app: add an install step to `packages.sh`. Prefer `omarchy install …` / `omarchy pkg add …` so Omarchy's own setup runs.
- A theme: add its git URL to `THEMES` in `packages.sh`.

Don't add a whole file just to change one line if Omarchy exposes a setting or command for it.
