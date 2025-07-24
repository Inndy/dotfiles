if [[ $- == *i* ]]; then
    function man() {
        local pager
        pager=$(command -v bat 2>/dev/null || command -v batcat 2>/dev/null)

        if [[ -t 1 && -n "$pager" ]]; then
            MANWIDTH=$(($(tput cols) - 9)) command man "$@" | col -b | "$pager" --language=man
        else
            command man "$@"
        fi
    }
fi

# vim: ft=bash
