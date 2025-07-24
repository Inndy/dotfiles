if [[ $- == *i* && $(command -v bat) ]]; then
	function man() {
		if [[ -t 1 ]]; then
			MANWIDTH=$(($(tput cols) - 9)) command man "$@" | col -b | bat --language=man
		else
			command man "$@"
		fi
	}
fi

# vim: ft=bash
