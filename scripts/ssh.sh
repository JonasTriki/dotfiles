#!/usr/bin/env bash
#
# Generates an SSH key for GitHub and registers it with the ssh-agent/Keychain.
# Usage: ./scripts/ssh.sh "you@example.com"

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <your-email-address>" >&2
  exit 1
fi

email="$1"
key="$HOME/.ssh/id_ed25519"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ -f "$key" ]; then
  echo "$key already exists, keeping it."
else
  echo "Generating a new SSH key for GitHub..."
  ssh-keygen -t ed25519 -C "$email" -f "$key"
fi

config="$HOME/.ssh/config"
touch "$config"
chmod 600 "$config"

if ! grep -qs 'UseKeychain' "$config"; then
  echo "Adding Keychain settings to $config..."
  cat >>"$config" <<EOF

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
fi

eval "$(ssh-agent -s)" >/dev/null

# --apple-use-keychain replaced -K in macOS 12; fall back for older systems.
ssh-add --apple-use-keychain "$key" 2>/dev/null || ssh-add -K "$key"

echo
if command -v gh >/dev/null 2>&1; then
  echo "Add the key to GitHub with:"
  echo "  gh auth login && gh ssh-key add $key.pub --title \"\$(scutil --get ComputerName)\""
else
  echo "Run 'pbcopy < $key.pub' and paste that into GitHub:"
  echo "  https://github.com/settings/ssh/new"
fi
