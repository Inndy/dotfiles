function paste()
{
	powershell.exe -Command Get-Clipboard
}

function copy()
{
	powershell.exe -Command 'Set-Clipboard ([Console]::In.ReadToEnd())'
}
