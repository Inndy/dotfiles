_fzf="$(which fzf)"

if [ -n "$_fzf" -a -x "$_fzf" ]
then
	__bash_plugin_j_list() {
		echo ..
		echo ../..
		echo ../../..
		echo ../../../..
		echo ../../../../..
		find . -maxdepth 4 -type d \( -name node_modules -o -name .git \) -prune -o -name '*' -type d -print 2>&-
	}
	j() {
		[ -n "$1" ] && local p="$1" || local p="$(__bash_plugin_j_list | fzf)"
		[ $? -eq 0 ] && cd "$p"
	}
fi

# vim: ft=bash
