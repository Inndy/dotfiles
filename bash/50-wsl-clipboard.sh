if [ -n "$WSL_DISTRO_NAME" -o -n "$WSLENV" ]
then
	function paste()
	{
		powershell.exe -Command '[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8; Get-Clipboard'
	}

	function copy()
	{
		powershell.exe -Command 'Set-Clipboard ([Console]::In.ReadToEnd())'
	}
fi
