# Aliases and shell functions. Sourced automatically by Oh My Zsh
# ($ZSH_CUSTOM/*.zsh), as is the gitignored aliases-private.zsh.

# --- Shortcuts --------------------------------------------------------------

alias reloadshell="exec zsh"
alias zshrc='${=EDITOR} $DOTFILES/dot_zshrc'
alias dotfiles="cd $DOTFILES"
alias repos="cd $HOME/repos"

# --- Listing ----------------------------------------------------------------

alias l='ls -lFh'
alias la='ls -lAFh'
alias ll='ls -l'
alias lt='ls -ltFh'
alias lS='ls -1FSsh'
alias ldot='ls -ld .*'

alias dud='du -d 1 -h'
alias duf='du -sh *'

# --- Files ------------------------------------------------------------------

# Route deletions to the macOS Trash so they are recoverable from Finder; use
# `\rm` for a real, permanent delete. /usr/bin/trash takes no -r/-f/-i/-v, so
# the rm-style flags are accepted and dropped.
rm() {
  local -a paths
  local arg no_more_flags=0

  for arg in "$@"; do
    if (( no_more_flags )); then
      paths+=("$arg")
    elif [[ "$arg" == "--" ]]; then
      no_more_flags=1
    elif [[ "$arg" == -* ]]; then
      continue
    else
      paths+=("$arg")
    fi
  done

  if (( ${#paths} == 0 )); then
    print -ru2 "rm: no paths given (routed to the Trash; use '\rm' to delete for real)"
    return 1
  fi

  command trash "${paths[@]}"
}

# --- Search -----------------------------------------------------------------

alias grep='grep --color'
alias h='history'
alias hgrep="fc -El 0 | grep"

# Complete hostnames already seen by ssh/scp/rsync.
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts \
  'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# --- Git --------------------------------------------------------------------

alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias lg="lazygit"

# --- Misc -------------------------------------------------------------------

alias t='tail -f'
alias p='ps -f'
alias sortnr='sort -n -r'

# PrettyFire: colourise the JSON lines in a piped log, pass the rest through.
alias pf='while read -r line; do if [[ $line =~ "^>  {\"" ]]; then echo -E ${line#">  "} | jq -C ; else echo $line; fi; done'
