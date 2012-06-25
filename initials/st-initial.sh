#!/bin/bash

echo "Server base installation/initialization script. Software shit's :) \n"
echo "Alexander Sergeychik aka OmeZ (c) 2012"


if [ "$(whoami)" != "root" ]
then
	echo "Warning! Script lounched with root access rights"
	#echo "Script should be executed with root access rights"
	#exit -1
fi

## INIT BASE VARIABLES
CURR_USER=$(whoami);
SCRIPT_DIR=$(dirname $0);
LOGS_DIR="var/log/st-initials";

if [ ! -d $LOGS_DIR ]
then
	sudo mkdir -p $LOGS_DIR
	sud chown $CURR_USER: $LOGS_DIR
fi

echo "-> working dir: $SCRIPT_DIR"
echo "-> log dir: $LOGS_DIR"

echo "Init OK"

## General
echo "-> Update system and install control tools"
#sudo apt-get update && sudo apt-get upgrade || exit 1;

sudo apt-get -y install mc htop openssh-server

## Guest additions
echo "-> Install Guest Additions"
if [ ! `VBoxControl -v` ]
then 

	sudo apt-get -y install build-essentials
	sudo mount /dev/cdrom /media/cdrom # mounting cdrom with guest additions executable
	executable="/media/cdrom/VBoxLinuxAdditions.run"
	if [ -f $executable ]
	then
		sudo $executable
		sudo usermod -a -G vboxsf $(whoami) # adding current user to vbox
	else
		echo "Unable to install guest additions"
		exit 1;
	fi
	
fi


## Mounting dedicated folder from Guest Additions 
echo "-> mount dedicated GuestAdditions folder"

if [ ! -d /ded ]
then
	# register new folder
	folders=`find /media -maxdepth 1 -type d -name sf_*`
	# first of them comes to DED
	first=${folders[0]}
	if [ -d $first ]
	then
		sudo ln -s $first /ded
		echo "-> created symbolic link to $first->/ded"
	fi
fi


## LAMP
sudo apt-get -y install apache2
sudo usermod -a -G vboxsf www-data #make apache user see additions

sudo apt-get -y install php5 php5-cli 

sudo apt-get -y install php5-curl php5-memcache php5-memcached php5-xdebug

sudo apt-get -y install phpunit

# database
sudo apt-get -y install mysql-server
sudo apt-get -y install phpmyadmin

#repos
sudo apt-get -y install subversion
sudo apt-get -y install git



## Pinba-specific libs
sudo apt-get -y install libprotobuf-dev libprotobuf-lite7 libprotobuf7 protobuf-compiler
sudo apt-get -y install libjudydebian1 libevent-dev libevent-2.0-5 libevent-core-2.0-5 libevent-extra-2.0-5 libevent-openssl-2.0-5 libevent-pthreads-2.0-5 

