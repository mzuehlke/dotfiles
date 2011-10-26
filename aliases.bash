# ls 
alias ll='ls -l'
alias la='ls -lA'
alias l='ls -CF'

# eclipse
alias mee='mvn eclipse:eclipse -DdownloadSources=true -DdownloadJavadocs=true'

#alias open="kde-open 2> /dev/null > /dev/null"
function open {
  if [ -z "$1" ]; then
    kde-open 2> /dev/null > /dev/null .
  else
    kde-open 2> /dev/null > /dev/null $1
  fi
}


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#
# https://bugs.launchpad.net/ubuntu/+source/bash/+bug/616028
# http://blog.dustinkirkland.com/2010/07/dear-command-line-please-ping-me-when.html
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# git
alias gs='git status'
alias gpr='git pull --rebase'
alias gmu='git merge @{upstream}'
alias gru='git rebase @{upstream}'
alias gld='git log --decorate --oneline'
alias glda='git log --decorate --oneline --all'
alias gl="git log --graph --pretty=format:'%C(bold red)%d%Creset %s %C(bold blue)<%an> %Cgreen(%cr)%Creset' --date=relative"
alias gla="git log --graph --pretty=format:'%C(bold red)%d%Creset %s %C(bold blue)<%an> %Cgreen(%cr)%Creset' --date=relative --all"
alias mgs='mgit-status all'
alias mgsv='mgit-status-verbose'
alias mgf='mgit-fetch all'
alias gk='gitk --all'
alias gkn='gitk ..@{upstream}'
alias git-update-cvsrepo='git cvsimport -v -k'

#calvalus
alias cvm='ssh hadoop@cvmaster00'
alias cv00='ssh hadoop@cvslave00'
alias cv01='ssh hadoop@cvslave01'
alias cv02='ssh hadoop@cvslave02'
alias cv03='ssh hadoop@cvslave03'
alias cv04='ssh hadoop@cvslave04'
alias cv05='ssh hadoop@cvslave05'
alias cv06='ssh hadoop@cvslave06'
alias cv07='ssh hadoop@cvslave07'
alias cv08='ssh hadoop@cvslave08'
alias cv09='ssh hadoop@cvslave09'
alias cv10='ssh hadoop@cvslave10'
alias cv11='ssh hadoop@cvslave11'
alias cv12='ssh hadoop@cvslave12'
alias cv13='ssh hadoop@cvslave13'
alias cv14='ssh hadoop@cvslave14'
alias cv15='ssh hadoop@cvslave15'
alias cv16='ssh hadoop@cvslave16'
alias cv17='ssh hadoop@cvslave17'
alias cv18='ssh hadoop@cvslave18'

alias cvfeeder='ssh hadoop@cvfeeder00'

export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS"
