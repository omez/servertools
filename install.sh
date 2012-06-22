#!/bin/bash

echo "Server Tools installation script by Alexander Sergeychik aka OmeZ (c) 2012"

if [ "$(whoami)" != "root" ]
then
	echo "Script should be executed with root access rights"
	exit 2
fi

TO_DIR="/usr/bin"

cd $(dirname $0)

ln -s -t $TO_DIR initials/st-initial.sh && chmod 755 $TO_DIR/st-initial.sh

ln -s -t $TO_DIR pm-tool/pm-tool.sh && chmod 755 $TO_DIR/pm-tool.sh