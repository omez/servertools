#!/bin/bash

echo "Server Tools installation script by Alexander Sergeychik aka OmeZ (c) 2012"

if [ "$(whoami)" != "root" ]
then
	echo "Script should be executed with root access rights"
	exit 2
fi

TO_DIR="/usr/bin"
CURRENT_DIR=$(dirname $0)
TOOLS=("initials/st-initial.sh" "pm-tool/pm-tool.sh")


cd $CURRENT_DIR;
echo "-> original dir: $PWD" 

for tool in ${TOOLS[@]}
do
	linkname=`basename ./$tool .sh`
	fullname=$TO_DIR/$linkname
	
	echo "-> registering $tool => $fullname"
	
	ln -f -s $PWD/$tool $fullname
done


echo "Done!"