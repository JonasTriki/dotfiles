#!/usr/bin/env bash
#
# Bootstraps a new Mac: installs the prerequisites chezmoi can't install for
# itself, then hands the dotfiles over to `chezmoi apply`.
# Safe to re-run — every step is idempotent.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES

echo "Setting up your Mac..."

# --- Xcode command line tools -----------------------------------------------

if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode command line tools"
  xcode-select --install
  echo "Finish the Xcode command line tools installer, then re-run this script."
  exit 1
fi

# --- Homebrew ---------------------------------------------------------------

if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available to the rest of this script and to future login shells.
eval "$(/opt/homebrew/bin/brew shellenv)"
if ! grep -qs 'brew shellenv' "$HOME/.zprofile"; then
  # shellcheck disable=SC2016 # the command substitution must stay literal
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.zprofile"
fi

# Only chezmoi is installed here. The rest of the Brewfile is installed by
# chezmoi's run_onchange script during `chezmoi apply` below.
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "==> Installing chezmoi"
  brew install chezmoi
fi

# --- Oh My Zsh --------------------------------------------------------------

# Must exist before chezmoi writes ~/.zshrc, which sources it. Custom plugins
# come from .chezmoiexternal.toml, not from the installer.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" \
    "" --unattended
fi

# --- chezmoi ----------------------------------------------------------------

# Point chezmoi at this repo instead of its default ~/.local/share/chezmoi.
# Machine-local on purpose: it is the one file that must exist before chezmoi
# can read the repo.
chezmoi_config="$HOME/.config/chezmoi/chezmoi.toml"
if [ ! -f "$chezmoi_config" ]; then
  echo "==> Configuring chezmoi"
  mkdir -p "$(dirname "$chezmoi_config")"
  cat >"$chezmoi_config" <<EOF
sourceDir = "$DOTFILES"
EOF
fi

echo "==> Applying dotfiles with chezmoi"
chezmoi apply

# --- Tooling ----------------------------------------------------------------

if command -v mise >/dev/null 2>&1; then
  echo "==> Installing runtimes with mise"
  mise install || echo "mise install reported errors; continuing"
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "==> Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

mkdir -p "$HOME/repos"

# --- Colima / Docker --------------------------------------------------------

# The socket only exists once Colima has started at least once.
if command -v colima >/dev/null 2>&1; then
  if ! colima status >/dev/null 2>&1; then
    echo "==> Starting Colima"
    colima start
  fi
  if [ -S "$HOME/.colima/default/docker.sock" ]; then
    echo "==> Linking the Colima socket to /var/run/docker.sock (needs sudo)"
    sudo ln -sfn "$HOME/.colima/default/docker.sock" /var/run/docker.sock
  fi

  # Symlink the Docker CLI plugins for docker-compose and docker-buildx.
  mkdir -p "$HOME/.docker/cli-plugins"
  ln -sfn "$HOMEBREW_PREFIX/opt/docker-compose/bin/docker-compose" "$HOME/.docker/cli-plugins/docker-compose"
  ln -sfn "$HOMEBREW_PREFIX/opt/docker-buildx/bin/docker-buildx" "$HOME/.docker/cli-plugins/docker-buildx"
fi

# --- macOS preferences ------------------------------------------------------

# Run last: this restarts Finder, Dock and friends.
echo "==> Applying macOS preferences"
"$DOTFILES/scripts/macos.sh"

cat <<'EOF'

Done. Open a new terminal (or run 'exec zsh') to pick up the new shell config.

On a work machine, create the gitignored private files (all optional):

  ~/.dotfiles/.zshrc-private        env vars, secrets, work tooling
  ~/.dotfiles/aliases-private.zsh   work aliases
  ~/.dotfiles/Brewfile.private      work-only packages, then run `task brew`
  ~/.dotfiles/gitconfig-private     git identity and work includeIf rules
EOF
