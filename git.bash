# taken from git-completition.bash in git 1.7.2 (mz)
#
#       Consider changing your PS1 to also show the current branch:
#        PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
#
#       The argument to __git_ps1 will be displayed only if you
#       are currently in a git repository.  The %s token will be
#       the name of the current branch.
#
#       In addition, if you set GIT_PS1_SHOWDIRTYSTATE to a nonempty
#       value, unstaged (*) and staged (+) changes will be shown next
#       to the branch name.  You can configure this per-repository
#       with the bash.showDirtyState variable, which defaults to true
#       once GIT_PS1_SHOWDIRTYSTATE is enabled.
#
#       You can also see if currently something is stashed, by setting
#       GIT_PS1_SHOWSTASHSTATE to a nonempty value. If something is stashed,
#       then a '$' will be shown next to the branch name.
#
#       If you would like to see if there're untracked files, then you can
#       set GIT_PS1_SHOWUNTRACKEDFILES to a nonempty value. If there're
#       untracked files, then a '%' will be shown next to the branch name.
#
#       If you would like to see the difference between HEAD and its
#       upstream, set GIT_PS1_SHOWUPSTREAM="auto".  A "<" indicates
#       you are behind, ">" indicates you are ahead, and "<>"
#       indicates you have diverged.  You can further control
#       behaviour by setting GIT_PS1_SHOWUPSTREAM to a space-separated
#       list of values:
#           verbose       show number of commits ahead/behind (+/-) upstream
#           legacy        don't use the '--count' option available in recent
#                         versions of git-rev-list
#           git           always compare HEAD to @{upstream}
#           svn           always compare HEAD to your SVN upstream
#       By default, __git_ps1 will compare HEAD to your SVN upstream
#       if it can find one, or @{upstream} otherwise.  Once you have
#       set GIT_PS1_SHOWUPSTREAM, you can override it on a
#       per-repository basis by setting the bash.showUpstream config
#       variable.
#

# __gitdir accepts 0 or 1 arguments (i.e., location)
# returns location of .git repo
__gitdir ()
{
        if [ -z "${1-}" ]; then
                if [ -n "${__git_dir-}" ]; then
                        echo "$__git_dir"
                elif [ -d .git ]; then
                        echo .git
                else
                        git rev-parse --git-dir 2>/dev/null
                fi
        elif [ -d "$1/.git" ]; then
                echo "$1/.git"
        else
                echo "$1"
        fi
}

# stores the divergence from upstream in $p
# used by GIT_PS1_SHOWUPSTREAM
__git_ps1_show_upstream_mz ()
{
	local key value
	local svn_remote=() svn_url_pattern count n
	local upstream=git legacy="" verbose=""

	# get some config options from git-config
	while read key value; do
		case "$key" in
		bash.showupstream)
			GIT_PS1_SHOWUPSTREAM="$value"
			if [[ -z "${GIT_PS1_SHOWUPSTREAM}" ]]; then
				p=""
				return
			fi
			;;
		svn-remote.*.url)
			svn_remote[ $((${#svn_remote[@]} + 1)) ]="$value"
			svn_url_pattern+="\\|$value"
			upstream=svn+git # default upstream is SVN if available, else git
			;;
		esac
	done < <(git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showupstream)$' 2>/dev/null | tr '\0\n' '\n ')

	# parse configuration values
	for option in ${GIT_PS1_SHOWUPSTREAM}; do
		case "$option" in
		git|svn) upstream="$option" ;;
		verbose) verbose=1 ;;
		legacy)  legacy=1  ;;
		esac
	done

	# Find our upstream
	case "$upstream" in
	git)    upstream="@{upstream}" ;;
	svn*)
		# get the upstream from the "git-svn-id: ..." in a commit message
		# (git-svn uses essentially the same procedure internally)
		local svn_upstream=($(git log --first-parent -1 \
					--grep="^git-svn-id: \(${svn_url_pattern:2}\)" 2>/dev/null))
		if [[ 0 -ne ${#svn_upstream[@]} ]]; then
			svn_upstream=${svn_upstream[ ${#svn_upstream[@]} - 2 ]}
			svn_upstream=${svn_upstream%@*}
			for ((n=1; "$n" <= "${#svn_remote[@]}"; ++n)); do
				svn_upstream=${svn_upstream#${svn_remote[$n]}}
			done

			if [[ -z "$svn_upstream" ]]; then
				# default branch name for checkouts with no layout:
				upstream=${GIT_SVN_ID:-git-svn}
			else
				upstream=${svn_upstream#/}
			fi
		elif [[ "svn+git" = "$upstream" ]]; then
			upstream="@{upstream}"
		fi
		;;
	esac

	# Find how many commits we are ahead/behind our upstream
	if [[ -z "$legacy" ]]; then
		count="$(git rev-list --count --left-right \
				"$upstream"...HEAD 2>/dev/null)"
	else
		# produce equivalent output to --count for older versions of git
		local commits
		if commits="$(git rev-list --left-right "$upstream"...HEAD 2>/dev/null)"
		then
			local commit behind=0 ahead=0
			for commit in $commits
			do
				case "$commit" in
				"<"*) let ++behind
					;;
				*)    let ++ahead
					;;
				esac
			done
			count="$behind	$ahead"
		else
			count=""
		fi
	fi

	# calculate the result
	if [[ -z "$verbose" ]]; then
		case "$count" in
		"") # no upstream
			p="" ;;
		"0	0") # equal to upstream
			p="=" ;;
		"0	"*) # ahead of upstream
			p=">" ;;
		*"	0") # behind upstream
			p="<" ;;
		*)	    # diverged from upstream
			p="<>" ;;
		esac
	else
		case "$count" in
		"") # no upstream
			p="${LIGHT_RED}NO UPSTREAM${NC}" ;;
		"0	0") # equal to upstream
			p="" ;;
		"0	"*) # ahead of upstream
			p=" ${LIGHT_RED}↑${count#0	}${NC}" ;;
		*"	0") # behind upstream
			p=" ${LIGHT_GREEN}↓${count%	0}${NC}" ;;
		*)	    # diverged from upstream
			p=" ${LIGHT_RED}↑${count#*	}${LIGHT_GREEN}↓${count%	*}${NC}" ;;
		esac
	fi

}


# __git_ps1 accepts 0 or 1 arguments (i.e., format string)
# returns text to add to bash PS1 prompt (includes branch name)
__git_ps1_mz ()
{
	local g="$(__gitdir)"
	if [ -n "$g" ]; then
		local r=""
		local b=""
		if [ -f "$g/rebase-merge/interactive" ]; then
			r="|REBASE-i"
			b="$(cat "$g/rebase-merge/head-name")"
		elif [ -d "$g/rebase-merge" ]; then
			r="|REBASE-m"
			b="$(cat "$g/rebase-merge/head-name")"
		else
			if [ -d "$g/rebase-apply" ]; then
				if [ -f "$g/rebase-apply/rebasing" ]; then
					r="|REBASE"
				elif [ -f "$g/rebase-apply/applying" ]; then
					r="|AM"
				else
					r="|AM/REBASE"
				fi
			elif [ -f "$g/MERGE_HEAD" ]; then
				r="|MERGING"
			elif [ -f "$g/BISECT_LOG" ]; then
				r="|BISECTING"
			fi

			b="$(git symbolic-ref HEAD 2>/dev/null)" || {

				b="$(
				case "${GIT_PS1_DESCRIBE_STYLE-}" in
				(contains)
					git describe --contains HEAD ;;
				(branch)
					git describe --contains --all HEAD ;;
				(describe)
					git describe HEAD ;;
				(* | default)
					git describe --exact-match HEAD ;;
				esac 2>/dev/null)" ||

				b="$(cut -c1-7 "$g/HEAD" 2>/dev/null)..." ||
				b="unknown"
				b="($b)"
			}
		fi

		local w=""
		local i=""
		local s=""
		local u=""
		local c=""
		local p=""

		if [ "true" = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]; then
			if [ "true" = "$(git rev-parse --is-bare-repository 2>/dev/null)" ]; then
				c="BARE:"
			else
				b="GIT_DIR!"
			fi
		elif [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
			if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ]; then
				if [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
					git diff --no-ext-diff --quiet --exit-code || w="*"
					if git rev-parse --quiet --verify HEAD >/dev/null; then
						git diff-index --cached --quiet HEAD -- || i="+"
					else
						i="#"
					fi
				fi
			fi
			if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ]; then
			        git rev-parse --verify refs/stash >/dev/null 2>&1 && s="$"
			fi

			if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ]; then
			   if [ -n "$(git ls-files --others --exclude-standard)" ]; then
			      u="%"
			   fi
			fi

			if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
				__git_ps1_show_upstream_mz
			fi
		fi

		local f="$w$i$s$u"
                if [ -n "${GIT_PS1_SHOWCOLORS-}" ]; then
		    echo -en "(${YELLOW}$c${b##refs/heads/}${LIGHT_PURPLE}${f:+ $f}${YELLOW}$r${NC}$p)"
                else
                    echo -en "($c${b##refs/heads/}${f:+ $f}$r$p)"
                fi
	fi
}

git_pager() {
        if test -t 1
        then
                GIT_PAGER=$(git var GIT_PAGER)
        else
                GIT_PAGER=cat
        fi
        : ${LESS=-FRSX}
        export LESS
        eval "$GIT_PAGER" '"$@"'
}

parse_all_parameter() {
echo $1;
case "$1" in
all)
        return 1
        ;;
*)
        return 0
        ;;
esac
}

# git stuff
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORS=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="git verbose"

PS1="${LIGHT_GREEN}\u@\h${NC}:${LIGHT_BLUE}\w${NC} \$(__git_ps1_mz)\$ "