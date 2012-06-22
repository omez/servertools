#!/bin/bash

echo "Server Tools installation script by Alexander Sergeychik aka OmeZ (c) 2012"

if [ "$(whoami)" != "root" ]
then
	echo "Script should be executed with root access rights"
	exit 2
fi

TO_DIR="/usr/local/bin"

cd $(dirname $0E)

