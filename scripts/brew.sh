#!/usr/bin/env bash
#
# Installs/updates everything in the Brewfile, plus Brewfile.private if present.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

brew update

echo "==> brew bundle (Brewfile)"
brew bundle install --file "$DOTFILES/Brewfile"

if [ -f "$DOTFILES/Brewfile.private" ]; then
  echo "==> brew bundle (Brewfile.private)"
  # --no-upgrade: `mas` can't update the Microsoft apps ("No downloads initiated
  # for ADAM ID"), which fails the whole bundle. Microsoft AutoUpdate updates
  # them instead, so only install what's missing, then upgrade formulae/casks.
  brew bundle install --no-upgrade --file "$DOTFILES/Brewfile.private"

  upgradable=()
  while IFS= read -r name; do
    [ -n "$name" ] && upgradable+=("$name")
  done < <(brew bundle list --formula --cask --file "$DOTFILES/Brewfile.private")
  if [ "${#upgradable[@]}" -gt 0 ]; then
    brew upgrade "${upgradable[@]}"
  fi
fi
