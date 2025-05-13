function t() {
    local T_FILE="${HOME}/.t_commands"
    local T_EDITOR="${EDITOR:-vi}"
    local T_CURRENT_DIR="$(pwd)/"

    mkdir -p "$(dirname "$T_FILE")"
    touch "$T_FILE"

    if [[ "$1" == "edit" ]]; then
        "$T_EDITOR" "$T_FILE"
        return
    fi

    if [[ "$1" == "new" || "$1" == "add" ]]; then
        shift
        local cmd="$*"
		if [ -z "$cmd" ]
		then
			read -p 'Command to add $ ' cmd
		fi
        echo -e "${T_CURRENT_DIR}\t${cmd}" >> "$T_FILE"
        echo "Added: [$cmd] for path [$T_CURRENT_DIR]"
        return
    fi

    # Read and filter commands matching current or parent directory
    local matching_cmds=()
    while IFS=$'\t' read -r path cmd; do
        if [[ "$T_CURRENT_DIR" == "$path"* ]]; then
            matching_cmds+=("$cmd")
        fi
    done < "$T_FILE"

    if [[ ${#matching_cmds[@]} -eq 0 ]]; then
        echo "No matching commands found for this directory."
        return 1
    fi

    # Use fzf to select a command
    local selected

	if [ -x "$(which fzf)" ]
	then
		selected=$(printf "%s\n" "${matching_cmds[@]}" | fzf --prompt="Select command to run: ")
	else
		select selected in "${matching_cmds[@]}"; do
			if [[ -n "$selected" ]]; then
				break
			else
				echo "Invalid selection. Try again."
			fi
		done
	fi

    if [[ -z "$selected" ]]; then
        echo "No command selected."
        return 1
    fi

	echo "\$ $selected"
    history -s "$selected"
    eval "$selected"
}
