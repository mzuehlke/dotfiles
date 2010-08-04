

#alias open="kde-open 2> /dev/null > /dev/null"
function open {
  if [ -z "$1" ]; then
    kde-open 2> /dev/null > /dev/null .
  else
    kde-open 2> /dev/null > /dev/null $1
  fi
}
# git
alias gs='git status'
alias gpr='git pull --rebase'
alias gld='git log --decorate --oneline'
alias gl="git log --graph --pretty=format:'%C(bold red)%d%Creset %s %C(bold blue)<%an> %Cgreen(%cr)%Creset' --date=relative"
alias gla="git log --graph --pretty=format:'%C(bold red)%d%Creset %s %C(bold blue)<%an> %Cgreen(%cr)%Creset' --date=relative --all"
alias mgs='mgit-status'
alias mgf='mgit-fetch'