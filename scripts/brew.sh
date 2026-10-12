#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

brew update
brew bundle install --file Brewfile

if [ -f Brewfile.private ]; then
  # mas can't update the Microsoft apps, so only install what's missing,
  # then upgrade the formulae and casks.
  brew bundle install --no-upgrade --file Brewfile.private
  brew bundle list --formula --cask --file Brewfile.private | xargs brew upgrade
fi
