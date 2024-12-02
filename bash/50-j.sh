_fzf="$(which fzf)"

if [ -n "$_fzf" -a -x "$_fzf" ]
then
	j() {
		[ -n "$1" ] && local p="$1" || local p="$(find . -maxdepth 3 -type d \( -name node_modules -o -name .git \) -prune -o -name '*' -type d -print 2>&- | fzf)"
		[ $? -eq 0 ] && cd "$p"
	}

	bind '"\C-j":"j\r"'
fi

# vim: ft=bash
