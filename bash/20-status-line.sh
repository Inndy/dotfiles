disable_git_branch_status() {
	DISABLE_GIT_PARSING=1
}

enable_git_branch_status() {
	DISABLE_GIT_PARSING=
}

__print_git_branch() {
	if [ -n "$DISABLE_GIT_PARSING" ]
	then
		echo -ne "\e[01;38;5;242m (GIT INFO OFF)${reset_color}"
		return
	fi

    local branch="$(git branch --no-color 2>&- | awk '{ if ($1 == "*" ) { print substr($0, 3) } }')"
    [ -z "$branch" ] && return

	if [ -z "$(git status --short 2>&1)" ]
	then
		# git repo is clean
		local git_status_color="${fg_green}"
	else
		local git_status_color="${fg_orange}"
	fi

	echo -ne " ${git_status_color}(${branch})${reset_color}"
}

#export VIRTUAL_ENV_DISABLE_PROMPT=1

# [ $DATE ] $USER @ $HOST $PWD $GIT_STATUS $VIRTUALENV_STATUS
# $

function __prompt_command() {
	local last_program_status="$?"
	PS1="\[${fg_yellow}\][ \$(date '+%m/%d %H:%M:%S') ] "
	PS1+="\[${fg_magenta}\]\u \[${reset_color}\]@ \[${fg_green}\]\h "
	PS1+="\[${fg_lightblue}\]\w"
	[ $last_program_status -ne 0 ] && PS1+=" \[${fg_pink}\](exit=$last_program_status)"
	__ps1_git_info="$(__print_git_branch)"
	PS1+="\${__ps1_git_info}"
	[ -n "$VIRTUAL_ENV" ] && {
		__ps1_venv_name=$(basename "$VIRTUAL_ENV")
		PS1+=" ${fg_yellow}(venv:\${__ps1_venv_name})${reset_color}"
	}
	PS1+="\n"
	PS1+="\[${vt100_bold}\]\$\[${reset_color}\] "
}

PROMPT_COMMAND="__prompt_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
