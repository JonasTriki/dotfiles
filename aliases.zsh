# Shortcuts
alias reloadshell="source $HOME/.zshrc"

# Directories
alias dotfiles="cd $DOTFILES"
alias repos="cd $HOME/repos"

# Git
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias stash="git stash -u"
alias unstage="git restore --staged ."

# Lazygit
alias lg="lazygit"

# PrettyFire
alias pf='while read -r line; do if [[ $line =~ "^>  {\"" ]]; then echo -E ${line#">  "} | jq -C ; else echo $line; fi; done'

# K8s
alias k="kubectl"
