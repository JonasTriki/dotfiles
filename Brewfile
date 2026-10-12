# Shared between the personal and the work Mac. Work-only packages go in the
# gitignored Brewfile.private. Check for drift with `task brew:check`.

# Taps
tap 'hashicorp/tap', trusted: true
tap 'oven-sh/bun', trusted: true

# Binaries
brew 'bash' # Latest Bash version
brew 'bat'
brew 'ffmpeg'
brew 'gh'
brew 'git'
brew 'git-lfs'
brew 'grep'
brew 'ripgrep' # `rg` — gitignore-aware recursive content search
brew 'fd' # gitignore-aware filename search
brew 'fzf' # Ctrl+R fuzzy history / Ctrl+T fuzzy file insert
brew 'wget'
brew 'jq'
brew 'chezmoi' # Dotfile manager
brew 'mas' # Mac App Store manager
brew 'shellcheck'
brew 'go'

# Development
cask 'iterm2'
brew 'mise' # Runtime version manager (node, python, java, ...)
brew 'cocoapods'
brew 'firebase-cli'
cask 'gcloud-cli'
brew 'cloud-sql-proxy'
cask 'azure-cli' # Moved from homebrew-core to a cask in 2026
brew 'docker'
brew 'docker-compose'
brew 'docker-credential-helper'
brew 'colima'
brew 'docker-buildx'
brew 'graphviz'
brew 'fastlane'
brew 'hashicorp/tap/terraform'
brew 'opentofu' # Alongside terraform: tofu for new work, terraform for existing
brew 'gnupg'
brew 'lazygit'
brew 'apktool'
brew 'htop'
brew 'kdoctor'
brew 'pdm'
brew 'uv'
brew 'rsync'
brew 'go-task'
brew 'goose'
brew 'helm'
brew 'watch'
brew 'postgresql@18' # Pinned: the `postgresql` alias silently follows new majors
brew 'kubectl'
brew 'k9s'
brew 'ack'
brew 'oven-sh/bun/bun'
brew 'anomalyco/tap/opencode-v2', trusted: true
brew 'kotlin'
brew 'ktlint'
brew 'gradle'
brew 'sops'
brew 'stripe'

# No trash formula: the `rm` wrapper uses macOS 26's built-in /usr/bin/trash,
# which the Homebrew alternatives collide with.

# Zsh
brew 'pure' # Prompt
# No `z` formula: the oh-my-zsh `z` plugin bundles its own implementation.

# Apps
cask 'caffeine'
cask 'discord'
cask 'google-chrome'
cask 'visual-studio-code'
cask 'zed'
cask 'flutter'
cask 'jetbrains-toolbox'
cask 'transmission'
cask 'rectangle'
cask 'keka'
cask 'bruno'
cask 'yubico-authenticator'
cask 'obsidian'
cask 'mitmproxy'
cask 'vlc'
cask 'scroll-reverser'
cask 'dbeaver-community'
cask 'opencode-desktop'
cask '1password'
cask '1password-cli'
cask 'codeql'
cask 'redis-insight'

# Fonts
cask 'font-lato'
cask 'font-open-sans'
cask 'font-roboto'
cask 'font-source-code-pro-for-powerline'
cask 'font-source-code-pro'
cask 'font-source-sans-3'
cask 'font-source-serif-4'
cask 'font-fira-code'
cask 'font-fira-mono'

# Mac App Store
mas 'Keynote', id: 409183694
mas 'Numbers', id: 409203825
mas 'Pages', id: 409201541
mas 'Xcode', id: 497799835

# Installed but not declared here, so a fresh machine needs them by hand:
#   Slack                       MAS copy; `mas` can't reinstall it
#   Microsoft 365, OneDrive,    present on one machine only
#   GarageBand, iMovie
