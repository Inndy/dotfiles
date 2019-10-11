test_ssh_agent()
{
	SSH_AUTH_SOCK="$1" ssh-add -l 2>&- >/dev/null
	[ $? -eq 2 ] && return 1
	return 0
}

auto_load_ssh_agent()
{

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
