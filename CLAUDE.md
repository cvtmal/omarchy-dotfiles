# Dotfiles for Omarchy machines

Files under `home/` are symlinked into `$HOME` by `link.sh`; `hosts/<hostname or DMI product name>/home/` overrides them per machine. `packages.sh` installs apps and themes beyond stock Omarchy.

- When you change a config on this machine that is tracked here, edit it through the symlink (or in `home/`) so the repo gets the change. If you change a tracked file that is currently not a symlink, run `./link.sh` afterwards.
- When you install an app or theme on this machine, add the step to `packages.sh` too. Keep each step idempotent: check first, print "already …" and move on.
- Prefer Omarchy commands (`omarchy install`, `omarchy pkg add`, `omarchy default`, `omarchy theme install`) over raw pacman/yay so Omarchy's own setup runs.
- Track only what differs from Omarchy's defaults in `/usr/share/omarchy/config/`. Never edit `/usr/share/omarchy/`.
- Keep machine-specific values (monitor scale, device names) in `hosts/`, not `home/`.
- Keep `job-watch` (its script, systemd units, bar plugin and config) out of this repo.
- Never commit secrets: `~/.codex/auth.json`, `~/.config/gh/hosts.yml`, SSH keys, tokens.
