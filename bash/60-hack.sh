function hack()
{
	POSITIONAL=()
	END_PARSE=N
	TEMPLATE=one4all
	while [[ $# -gt 0 ]]; do
		key="$1"
		if [ $END_PARSE = N ]; then
			case $key in
				-d|--dll)
					TEMPLATE=dll
					shift
					;;
				--)
					END_PARSE=Y
					;;
				-*)
					echo "Unkown option $key" >&2
					return 1
					;;
				*)
					POSITIONAL+=("$1")
					shift
					;;
			esac
		else
			POSITIONAL+=("$1")
			shift
		fi
	done

	set -- "${POSITIONAL[@]}"

	file="$1"
	[ -z "$file" ] && file=hackthis.c
	[ -z "$EDITOR" ] && EDITOR=vim

	if [ ! -f "$file" ]
	then
		if [ $TEMPLATE = one4all ]; then
cat >> "$file" <<__EOF__
// https://github.com/Inndy/one4all
#include "/home/inndy/one4all/one4all.h"

int main(int argc, char *argv[])
{
	// TODO: start hacking!!!

	return 0;
}
__EOF__
		elif [ $TEMPLATE = dll ]; then
cat >> "$file" <<__EOF__
#include <windows.h>

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
	switch(fdwReason) {
		case DLL_PROCESS_ATTACH:
			break;
		case DLL_PROCESS_DETACH:
			break;
		case DLL_THREAD_ATTACH:
			break;
		case DLL_THREAD_DETACH:
			break;
	}

	return TRUE;
}
__EOF__
		fi
	fi

	$EDITOR "$file"
}
