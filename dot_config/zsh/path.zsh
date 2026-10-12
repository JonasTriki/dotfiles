path=("$HOME/.local/bin" $path)
[[ -d "$DOTFILES/bin" ]] && path=("$DOTFILES/bin" $path)
[[ -d "$HOME/.pub-cache/bin" ]] && path+=("$HOME/.pub-cache/bin")

if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path+=("$ANDROID_HOME"/{cmdline-tools/latest/bin,platform-tools,emulator})
fi

typeset -U path PATH
path=($^path(N-/))  # drop missing directories

# Add ./node_modules/.bin and ./vendor/bin on cd. Appended, so they can't
# shadow system commands.
typeset -ga _project_bins
_project_bin_path() {
  local dir
  for dir in $_project_bins; do path=("${(@)path:#$dir}"); done
  _project_bins=()
  for dir in "$PWD/node_modules/.bin" "$PWD/vendor/bin"; do
    [[ -d "$dir" ]] && path+=("$dir") && _project_bins+=("$dir")
  done
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _project_bin_path
_project_bin_path
