#!/bin/bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$DOTFILES/link.sh"
"$DOTFILES/packages.sh"

hyprctl reload >/dev/null 2>&1 || true

echo
echo "the dotfiles are installed"
echo "open a new terminal to load the shell changes"
