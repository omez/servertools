@echo off

set HOST=%1.local.dev


if (%HOST% == "") (
	echo "Host not set"
) else (
	echo 192.168.56.101	%HOST%	 # added hostname %HOST% >> c:\Windows\System32\drivers\etc\hosts
	echo %HOST% added to hosts file
)

pause