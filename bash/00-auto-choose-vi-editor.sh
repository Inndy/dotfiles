[ -z "$VI" -a -x "$(which nvim 2>&-)" ] && VI=nvim
[ -z "$VI" -a -x "$(which vim 2>&-)" ] && VI=vim
[ -z "$VI" ] && VI=vi

export VI
export EDITOR=$VI
