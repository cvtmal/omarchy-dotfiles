#!/bin/bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${DOTFILES_UPGRADED:-}" ]; then
  echo "updating the dotfiles..."
  git -C "$DOTFILES" pull --ff-only
  exec env DOTFILES_UPGRADED=1 "$DOTFILES/upgrade.sh" "$@"
fi

"$DOTFILES/install.sh"

echo "updating the themes..."
omarchy theme update

omarchy update

echo
echo "the machine is upgraded"
