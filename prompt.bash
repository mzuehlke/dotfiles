source /etc/bash_completion.d/git

function prompt_command_mz {

  
  # git stuff
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  unset GIT_PS1_SHOWUPSTREAM

  local git_ps1=$(__git_ps1 "%s")
  if [[ -z ${git_ps1} ]];then
    PS1="\[${LIGHT_GREEN}\]\u \[${LIGHT_BLUE}\]\w\[${NC}\] \$ "
  else

    local arr2=($git_ps1)
    local g_branch=${arr2[0]}
    local g_flags=${arr2[1]}

    if [[ -n ${1} ]]; then 
     echo -en "${LIGHT_BLUE}${1/$HOME/~}${NC} (${YELLOW}${g_branch}${LIGHT_PURPLE}${g_flags:+ $g_flags}"
    fi
    GIT_PS1_SHOWUPSTREAM="git verbose"
    local p=""
    __git_ps1_show_upstream
    unset GIT_PS1_SHOWUPSTREAM

    local g_upstream
    if [[ $p =~ \ u= ]]; then
      g_upstream=""
    elif [[ $p == "" ]]; then
      g_upstream=" \[${LIGHT_RED}\]NO UPSTREAM\[${NC}\]"
      if [[ -n ${1} ]]; then  echo -en " ${LIGHT_RED}NO UPSTREAM"; fi;
    elif [[ $p =~ \ u\+([0-9])+\-([0-9]+) ]]; then
      g_upstream=" \[${LIGHT_RED}\]↑${BASH_REMATCH[1]}\[${LIGHT_GREEN}\]↓${BASH_REMATCH[2]}\[${NC}\]"
      if [[ -n ${1} ]]; then  echo -en " ${LIGHT_RED}↑${BASH_REMATCH[1]}${LIGHT_GREEN}↓${BASH_REMATCH[2]}"; fi;
    elif [[ $p =~ \ u\-([0-9]+) ]]; then
      g_upstream=" \[${LIGHT_GREEN}\]↓${BASH_REMATCH[1]}\[${NC}\]"   
      if [[ -n ${1} ]]; then  echo -en " ${LIGHT_GREEN}↓${BASH_REMATCH[1]}"; fi;   
    elif [[ $p =~ \ u\+([0-9])+ ]]; then
      g_upstream=" \[${LIGHT_RED}\]↑${BASH_REMATCH[1]}\[${NC}\]"
      if [[ -n ${1} ]]; then  echo -en " ${LIGHT_RED}↑${BASH_REMATCH[1]}"; fi;
    fi
  
    if [[ -n ${1} ]]; then
      echo -e "${NC})"; 
    else
      PS1="\[${LIGHT_GREEN}\]\u \[${LIGHT_BLUE}\]\w\[${NC}\] (\[${YELLOW}\]${g_branch}\[${LIGHT_PURPLE}\]${g_flags:+ $g_flags}\[${NC}\]${g_upstream})\$ "
    fi  
  fi

  if [[ -z ${1} ]]; then
    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
      xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
      *)
        ;;
    esac
 fi
}

PROMPT_COMMAND=prompt_command_mz