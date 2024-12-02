parse_git_branch() {
    git branch --no-color 2>&- | awk '{ if ($1 == "*" ) { print substr($0, 3) } }'
}

disable_git_branch_status() {
	DISABLE_GIT_PARSING=1
}

enable_git_branch_status() {
	DISABLE_GIT_PARSING=
}

print_git_branch() {
	if [ -n "$DISABLE_GIT_PARSING" ]
	then
		echo -ne "\e[01;38;5;242m (GIT INFO OFF)${reset_color}"
		return
	fi

    local branch="$(parse_git_branch)"
	if [ -z "$(git status --short 2>&1)" ]
	then
		# git repo is clean
		local git_status_color="${fg_green}"
	else
		local git_status_color="${fg_orange}"
	fi

    [ -z "$branch" ] && return

	echo -ne " ${git_status_color}(${branch})${reset_color}"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
print_virtualenv() {
	[ -z "$VIRTUAL_ENV" ] && return
	venv_name=$(basename "$VIRTUAL_ENV")
	echo -ne " ${fg_yellow}(venv:${venv_name})${reset_color}"
}

# [ $DATE ] $USER @ $HOST $PWD $GIT_STATUS $VIRTUALENV_STATUS
# $

PS1=\
"\[${fg_yellow}\][ \$(date '+%m/%d %H:%M:%S') ] "\
"\[${fg_magenta}\]\u \[${reset_color}\]@ \[${fg_green}\]\h "\
"\[${fg_lightblue}\]\w"\
"\$(print_git_branch)"\
"\$(print_virtualenv)"\
"\n"\
"\[${vt100_bold}\]\$\[${reset_color}\] "
