#!/bin/bash

# Links every file under home/ (and hosts/<this machine>/home/, which wins on
# a clash) into $HOME at the same path.
#
# Some apps save with an atomic write (temp file + rename), which replaces our
# symlink with a regular file — the Omarchy shell does this to shell.json. A
# file we linked before that is now a regular file is copied back into the repo
# before it is linked again, so the change shows up in `git diff` instead of
# being lost. A file we never linked is backed up instead.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
LINKED="$STATE/linked"
BACKUP="$STATE/backup/$(date +%Y%m%d-%H%M%S)"

host_dir() {
  local name
  for name in "$(uname -n)" "$(cat /sys/class/dmi/id/product_name 2>/dev/null)"; do
    if [[ -n $name && -d $DOTFILES/hosts/$name/home ]]; then
      echo "$DOTFILES/hosts/$name/home"
      return
    fi
  done
}

mkdir -p "$STATE"
touch "$LINKED"

roots=("$DOTFILES/home")
host="$(host_dir)"
[[ -n $host ]] && roots+=("$host")

declare -A sources
for root in "${roots[@]}"; do
  echo "using ${root#"$DOTFILES/"}"
  while IFS= read -r -d '' src; do
    sources["${src#"$root/"}"]="$src"
  done < <(find "$root" -type f -print0)
done

while IFS= read -r path; do
  src="${sources[$path]}"
  target="$HOME/$path"

  if [[ -L $target && $(readlink "$target") == "$src" ]]; then
    continue
  fi

  if [[ -f $target && ! -L $target ]] && ! cmp -s "$target" "$src"; then
    if grep -Fxq "$path" "$LINKED"; then
      cp "$target" "$src"
      echo "adopted ~/$path (an app replaced the link, review with git diff)"
    else
      mkdir -p "$(dirname "$BACKUP/$path")"
      cp "$target" "$BACKUP/$path"
      echo "backed up ~/$path to ${BACKUP/#$HOME/\~}/$path"
    fi
  fi

  mkdir -p "$(dirname "$target")"
  ln -sfn "$src" "$target"
  grep -Fxq "$path" "$LINKED" || echo "$path" >>"$LINKED"
  echo "linked ~/$path"
done < <(printf '%s\n' "${!sources[@]}" | sort)
