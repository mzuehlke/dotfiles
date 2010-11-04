
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
