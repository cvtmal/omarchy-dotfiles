#!/bin/bash

# Installs what this setup adds on top of a stock Omarchy install. Safe to run
# again: a step that is already done says so and moves on.

set -euo pipefail

THEME="Japan Night"
THEMES=(
  https://github.com/devgtv/omarchy-japan-night-theme
  https://github.com/nunomaduro/omarchy-laravel-theme.git
  https://github.com/phuclh/omarchy-lawson-night-theme
  https://github.com/BVisagie/omarchy-matrix-theme
  https://github.com/mwaltzer/omarchy-nagai-poolside-theme
  https://github.com/bjarneo/omarchy-nes-theme
  https://github.com/TyRichards/omarchy-super-game-bro-theme
  https://github.com/cvtmal/omarchy-symfony-night-theme.git
)

if [[ $(omarchy default terminal) == ghostty ]]; then
  echo "ghostty already the default terminal"
else
  echo "installing ghostty as the default terminal..."
  omarchy install terminal ghostty
fi

if pacman -Q brave-bin >/dev/null 2>&1; then
  echo "brave already installed"
else
  echo "installing brave..."
  omarchy install browser brave
fi

if [[ $(omarchy default browser) == brave ]]; then
  echo "brave already the default browser"
else
  echo "setting brave as the default browser..."
  omarchy default browser brave
fi

echo "installing sublime text and the codex desktop app..."
omarchy pkg add sublime-text-4 openai-codex-desktop

if pacman -Q voxtype-bin >/dev/null 2>&1; then
  echo "voxtype already installed"
else
  echo "installing voxtype dictation..."
  omarchy-voxtype-install
fi

echo "installing the mise tools..."
mise install

fresh_themes=0
for url in "${THEMES[@]}"; do
  name="$(basename "$url" .git)"
  name="${name#omarchy-}"
  name="${name%-theme}"
  name="${name,,}"

  if [[ -d $HOME/.config/omarchy/themes/$name ]]; then
    echo "theme $name already installed"
  else
    echo "installing theme $name..."
    omarchy theme install "$url"
    fresh_themes=1
  fi
done

if (( fresh_themes )); then
  echo "applying the $THEME theme..."
  omarchy theme set "$THEME"
fi
