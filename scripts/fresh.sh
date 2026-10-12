#!/usr/bin/env bash
# Bootstraps a new Mac. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Re-run this script once the Xcode tools are installed."
  exit 1
fi

if ! command -v brew >/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
# shellcheck disable=SC2016
grep -qs 'brew shellenv' ~/.zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile

command -v chezmoi >/dev/null || brew install chezmoi

if [ ! -d ~/.oh-my-zsh ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" "" --unattended
fi

# Point chezmoi at this repo, then apply. This also installs the Brewfiles.
mkdir -p ~/.config/chezmoi
[ -f ~/.config/chezmoi/chezmoi.toml ] || echo "sourceDir = \"$DOTFILES\"" >~/.config/chezmoi/chezmoi.toml
chezmoi apply

mise install
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
mkdir -p ~/repos

if command -v colima >/dev/null; then
  colima status >/dev/null 2>&1 || colima start
  sudo ln -sfn ~/.colima/default/docker.sock /var/run/docker.sock
  mkdir -p ~/.docker/cli-plugins
  ln -sfn "$HOMEBREW_PREFIX/opt/docker-compose/bin/docker-compose" ~/.docker/cli-plugins/
  ln -sfn "$HOMEBREW_PREFIX/opt/docker-buildx/bin/docker-buildx" ~/.docker/cli-plugins/
fi

"$DOTFILES/scripts/macos.sh"  # last: restarts Finder and Dock

echo "Done. Open a new terminal."
