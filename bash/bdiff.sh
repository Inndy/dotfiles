function bdiff()
{
	if [ -z "$2" ]
	then
		echo "Usage: bdiff file1 file2"
		return
	fi

	if [ -f "$1" -a -r "$1" -a -f "$2" -a -r "$2" ]
	then
		vimdiff <(xxd -g1 "$1") <(xxd -g1 "$2")
	else
		echo "Unable to read file(s)"
	fi
}
