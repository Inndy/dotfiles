test_ssh_agent()
{
	SSH_AUTH_SOCK="$1" ssh-add -l 2>&- >/dev/null
	[ $? -eq 2 ] && return 1
	return 0
}

auto_load_ssh_agent()
{
	[ -z "$SSH_AUTH_SOCK" -a -n ${WSL_AUTH_SOCK} ] && {
		export SSH_AUTH_SOCK=${WSL_AUTH_SOCK}
		return
	}
	test_ssh_agent "$SSH_AUTH_SOCK" && return

	for f in /tmp/ssh-*/agent.*
	do
		[ ! -e "$f" ] && continue

		test_ssh_agent "$f" && \
			export SSH_AUTH_SOCK="$f" && \
			return
	done

	eval `ssh-agent` >/dev/null
}

auto_load_ssh_agent
