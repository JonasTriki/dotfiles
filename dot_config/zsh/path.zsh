# $PATH setup. Sourced automatically by Oh My Zsh ($ZSH_CUSTOM/*.zsh).

path=("$HOME/.local/bin" $path)

[[ -d "$DOTFILES/bin" ]] && path=("$DOTFILES/bin" $path)
[[ -d "$HOME/.pub-cache/bin" ]] && path+=("$HOME/.pub-cache/bin")

if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  for android_dir in \
    "$ANDROID_HOME/cmdline-tools/latest/bin" \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/emulator"
  do
    [[ -d "$android_dir" ]] && path+=("$android_dir")
  done
  unset android_dir
fi

# Drop duplicate and non-existent entries.
typeset -U path PATH
path=($^path(N-/))

# Project-local binaries, refreshed on every cd. Resolved to absolute paths and
# appended rather than prepended, so a repo shipping node_modules/.bin/git can't
# shadow the real one.
typeset -ga _project_bin_added

_project_bin_path() {
  local dir

  for dir in $_project_bin_added; do
    path=("${(@)path:#$dir}")
  done
  _project_bin_added=()

  for dir in "$PWD/node_modules/.bin" "$PWD/vendor/bin"; do
    if [[ -d "$dir" ]]; then
      path+=("$dir")
      _project_bin_added+=("$dir")
    fi
  done

  typeset -gU path PATH
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _project_bin_path
_project_bin_path
