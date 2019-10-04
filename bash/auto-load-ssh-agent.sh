test_ssh_agent()
{
	[ -n "$SSH_AUTH_SOCK" ] && SOCK="$SSH_AUTH_SOCK"
	[ -n "$1" ] && SOCK="$1"
	[ -r "$SOCK" -a -w "$SOCK" ]
}

auto_load_ssh_agent()
{

	test_ssh_agent && return

	for f in /tmp/ssh-*/agent.*
	do
		[ ! -e "$f" ] && continue

		test_ssh_agent "$f" && \
			export SSH_AUTH_SOCK=$f && \
			export SSH_AGENT_PID=${f##*.} && \
			return

		rm -r "$(dirname $f)"
	done

	eval `ssh-agent` >/dev/null
}

auto_load_ssh_agent
