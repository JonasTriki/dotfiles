#!/usr/bin/env bash
# Usage: ssh.sh <email>
set -euo pipefail

key="$HOME/.ssh/id_ed25519"
mkdir -p ~/.ssh && chmod 700 ~/.ssh

[ -f "$key" ] || ssh-keygen -t ed25519 -C "${1:?Usage: $0 <email>}" -f "$key"

touch ~/.ssh/config && chmod 600 ~/.ssh/config
grep -qs UseKeychain ~/.ssh/config || cat >>~/.ssh/config <<EOF

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF

eval "$(ssh-agent -s)" >/dev/null
ssh-add --apple-use-keychain "$key"

echo "Add the key to GitHub: gh ssh-key add $key.pub"
