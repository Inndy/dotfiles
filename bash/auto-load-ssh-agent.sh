test_ssh_agent()
{
	[ -r "$1" -a -w "$1" ] && \
	ps -q "$2" >/dev/null
}

auto_load_ssh_agent()
{

	test_ssh_agent "$SSH_AUTH_SOCK" "$SSH_AGENT_PID" && return

	for f in /tmp/ssh-*/agent.*
	do
		[ ! -e "$f" ] && continue

		pid=${f##*.}
		test_ssh_agent "$f" "$pid" && \
			export SSH_AUTH_SOCK="$f" && \
			export SSH_AGENT_PID="$pid" && \
			return

		rm -r "$(dirname $f)"
	done

	eval `ssh-agent` >/dev/null
}

auto_load_ssh_agent
