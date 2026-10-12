alias reloadshell="exec zsh"
alias zshrc='${=EDITOR} $DOTFILES/dot_zshrc'
alias dotfiles="cd $DOTFILES"
alias repos="cd $HOME/repos"

# --- Files

alias l='ls -lFh'
alias la='ls -lAFh'
alias ll='ls -l'
alias lt='ls -ltFh'
alias lS='ls -1FSsh'
alias ldot='ls -ld .*'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Move to the Trash instead of deleting. rm-style flags are ignored.
rm() {
  local -a paths
  local arg end=0
  for arg in "$@"; do
    if (( end )) || [[ "$arg" != -* ]]; then paths+=("$arg")
    elif [[ "$arg" == "--" ]]; then end=1
    fi
  done
  (( ${#paths} )) || { print -u2 "rm: no paths given"; return 1; }
  command trash "${paths[@]}"
}

# --- Search

alias grep='grep --color'
alias h='history'
alias hgrep="fc -El 0 | grep"

# Complete hosts from known_hosts for ssh/scp/rsync.
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts \
  'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# --- Git

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

# --- Misc

alias t='tail -f'
alias p='ps -f'
alias sortnr='sort -n -r'

# Pretty-print the JSON lines in Firebase logs.
alias pf='while read -r line; do if [[ $line =~ "^>  {\"" ]]; then echo -E ${line#">  "} | jq -C ; else echo $line; fi; done'
