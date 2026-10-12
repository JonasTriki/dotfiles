# ~./* :rocket:

My personal dotfiles, mainly used for my Macbook. Managed with
[chezmoi](https://chezmoi.io). Heavily inspired by
[driesvints/dotfiles](https://github.com/driesvints/dotfiles).

Anything work-related lives in gitignored private files (see
[Personal vs work](#personal-vs-work)), so this repo stays publishable.

## First time setup

1. Update macOS to the latest version through System Settings
2. [Generate a new public and private SSH key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) by running:

   ```zsh
   curl -fsSL https://raw.githubusercontent.com/JonasTriki/dotfiles/HEAD/scripts/ssh.sh | bash -s "<your-email-address>"
   ```

3. Clone this repo to `~/.dotfiles` with:

    ```zsh
    git clone git@github.com:JonasTriki/dotfiles.git ~/.dotfiles
    ```

4. Run the installation with:

    ```zsh
    ~/.dotfiles/scripts/fresh.sh
    ```

`fresh.sh` installs the prerequisites chezmoi can't install for itself (Xcode
CLT, Homebrew, Oh My Zsh), points chezmoi at this repo, then hands over to
`chezmoi apply`. It is idempotent — safe to re-run at any time.

## Day-to-day

Everything is wrapped in [go-task](https://taskfile.dev). Run `task` to list:

```zsh
task diff         # what `task apply` would change in $HOME
task apply        # apply the dotfiles
task update       # brew packages + zsh plugins + Oh My Zsh + mise runtimes
task brew:drift   # what's installed here but missing from the Brewfile(s)
task secrets      # assert no private file is tracked by git
task doctor       # chezmoi health check
task lint         # shellcheck the scripts in this repo
task startup      # measure zsh startup time
```

**Edit the source, not the target.** `~/.zshrc` is a real file written by
chezmoi, not a symlink — changing it directly will be overwritten on the next
apply. Edit `dot_zshrc` here and run `task apply`. (`chezmoi edit ~/.zshrc`
opens the right file for you.)

## Layout

chezmoi maps source names to target paths: `dot_zshrc` → `~/.zshrc`,
`dot_config/zsh/` → `~/.config/zsh/`. Source files whose names begin with `.`
are ignored by chezmoi; everything else repo-only is listed in `.chezmoiignore`.

```
dot_zshrc                     → ~/.zshrc
dot_gitconfig                 → ~/.gitconfig
dot_config/
  zsh/aliases.zsh             → ~/.config/zsh/aliases.zsh
  zsh/path.zsh                → ~/.config/zsh/path.zsh
  git/ignore                  → ~/.config/git/ignore
  mise/config.toml            → ~/.config/mise/config.toml
.chezmoiexternal.toml         → ~/.config/zsh/plugins/ (cloned + updated)
.chezmoiscripts/              re-runs scripts/brew.sh when a Brewfile changes
.chezmoiignore                repo-only files, never installed into $HOME
Brewfile                      Homebrew CLIs, casks, fonts and MAS apps
scripts/
  fresh.sh                    bootstrap a new machine
  brew.sh                     brew update + brew bundle for both Brewfiles
  macos.sh                    macOS defaults; run last, restarts Finder/Dock
  ssh.sh                      SSH key generation
init/                         app config imported by macos.sh (Rectangle)
Taskfile.yml                  task runner entrypoints
```

`~/.config/zsh` is `$ZSH_CUSTOM`, so Oh My Zsh sources `aliases.zsh` and
`path.zsh` automatically.

## Personal vs work

Work-specific configuration never enters git. Each private file is gitignored
*and* excluded from chezmoi, and is loaded only if it exists — so a machine
without them works fine.

| File (in `~/.dotfiles/`) | Loaded by | Contents |
| --- | --- | --- |
| `.zshrc-private` | `dot_zshrc`, sourced last | Env vars, secrets, work tooling |
| `aliases-private.zsh` | `dot_zshrc`, sourced last | Work aliases and functions |
| `Brewfile.private` | `scripts/brew.sh`, after `Brewfile` | Work-only packages and MAS apps |
| `gitconfig-private` | `dot_gitconfig` via `[include]` | Git identity, work `includeIf` rules |

Git identity lives entirely in `gitconfig-private`, so no email address is
committed. To use a separate identity for work repos, add an `includeIf` there:

```gitconfig
[includeIf "gitdir:~/repos/work/"]
    path = ~/.dotfiles/gitconfig-work
```

Run `task secrets` to assert none of these ever got staged.

Secrets should not be stored in plaintext in `.zshrc-private`. Prefer reading
them at use time — `export FOO="$(op read 'op://Private/Item/field')"`, or
wrapping commands with `op run --`. chezmoi also has native support for
1Password and Proton Pass (`pass-cli`) if you'd rather template them in.

## Notable shell behaviour

- **`rm` moves to the Trash.** It's a shell function wrapping the
  `/usr/bin/trash` built into macOS 26+, so deletions are recoverable via Finder's *Put Back*.
  `-r`/`-f`/`-i`/`-v` are accepted and ignored. Use `\rm` for a real,
  permanent delete.
- **`Ctrl+R`** is fuzzy history search and **`Ctrl+T`** inserts a fuzzy-picked
  file path, via `fzf`.
- **`$EDITOR` is `zed --wait`**, falling back to `vim` over SSH.
- **`common-aliases` is not loaded.** Its global `alias -g` definitions (H, T,
  G, L, ...) expand anywhere on the line, so `git commit -m T` silently became
  `git commit -m | tail`. The useful `ls`/`du` shortcuts live in `aliases.zsh`.
- **`diff` is not aliased to `git diff`** — shadowing a POSIX command breaks
  scripts. Use `gd` from the git plugin.

## Runtimes

Runtimes are managed by [mise](https://mise.jdx.dev), configured in
`dot_config/mise/config.toml`, which replaced `nvm`, `pyenv` and `rbenv`.
Use `mise use -g node@24` and commit the result.
