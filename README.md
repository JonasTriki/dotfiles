# ~./* :rocket:

My dotfiles for macOS, managed with [chezmoi](https://chezmoi.io). Inspired by
[driesvints/dotfiles](https://github.com/driesvints/dotfiles).

## Setup

1. Update macOS.
2. Create an SSH key:

   ```zsh
   curl -fsSL https://raw.githubusercontent.com/JonasTriki/dotfiles/HEAD/scripts/ssh.sh | bash -s "<email>"
   ```

3. Clone and install:

   ```zsh
   git clone git@github.com:JonasTriki/dotfiles.git ~/.dotfiles
   ~/.dotfiles/scripts/fresh.sh
   ```

## Usage

Run `task` to list commands. Edit files here, not in `$HOME`, then `task apply`.

| Source | Target |
| --- | --- |
| `dot_zshrc` | `~/.zshrc` |
| `dot_gitconfig` | `~/.gitconfig` |
| `dot_config/` | `~/.config/` |

## Work vs personal

Work and secret config lives in gitignored files, loaded only if present:

| File | Contents |
| --- | --- |
| `.zshrc-private` | Env vars and secrets |
| `aliases-private.zsh` | Aliases |
| `Brewfile.private` | Packages |
| `gitconfig-private` | Git identity |

## Notes

- `rm` moves files to the Trash. Use `\rm` to delete permanently.
- Runtimes (node, python, java) are managed by mise.
