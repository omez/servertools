#!/bin/bash

echo "Configuration manager. Add/Remove development hosts \n"
echo "Alexander Sergeychik aka OmeZ (c) 2012"
echo "USAGE: pm-tool <projectname> [<hostname>]"

if [ "$(whoami)" == "root" ]
then
	echo "Script should be executed with server user access rights, not root"
	exit -1
fi


## Configuration variables
PROJECT_LOCAL_CONFIGS_DIRNAME="config.local"
PROJECT_LOCAL_LOGS_DIRNAME="logs"
#APACHE_CONF_DIR="/etc/apache2"
APACHE_DIST_CONFIG="apache.conf.dist"
SCRIPT_DIR=$(dirname $(readlink -f $0));
echo "-> working script dir: $SCRIPT_DIR"
if [ $SCRIPT_DIR == "" ]
then
	SCRIPT_DIR="."
fi


## User variables
PROJECTNAME=$1
if [ "$PROJECTNAME" == "" ]
then
	echo "Project name should be set"
	exit -1;
fi

HOSTNAME=$2
if [ "$HOSTNAME" = "" ]
then
	HOSTNAME="$PROJECTNAME.local.dev"
fi


echo "-> creating project <$PROJECTNAME> on host <$HOSTNAME>"

# define and create directory for project
PROJECTDIR="$PWD/$PROJECTNAME"
if [ -d $PROJECTDIR ]
then
	echo "Warning: directory $PROJECTDIR already exists"
else
	mkdir -p $PROJECTDIR
fi

# put local configurations and logs
PROJECTDIR_CONF="$PROJECTDIR/$PROJECT_LOCAL_CONFIGS_DIRNAME"
PROJECTDIR_LOG="$PROJECTDIR/$PROJECT_LOCAL_LOGS_DIRNAME"

mkdir -p $PROJECTDIR_CONF
mkdir -p $PROJECTDIR_LOG
mkdir -p $PROJECTDIR/public


#### CONFIGURING LOCAL APACHE FILE
PROJECT_APACHE_CONFIG_FILE="$PROJECTDIR/$PROJECT_LOCAL_CONFIGS_DIRNAME/apache.conf"

## creating tmp apache file
PROJECT_APACHE_CONFIG_FILE_TMP="$PROJECT_APACHE_CONFIG_FILE~"

cat $SCRIPT_DIR/$APACHE_DIST_CONFIG > $PROJECT_APACHE_CONFIG_FILE || exit -2;

sed -e "s/{%projectname%}/$PROJECTNAME/g" $PROJECT_APACHE_CONFIG_FILE > $PROJECT_APACHE_CONFIG_FILE~ && mv $PROJECT_APACHE_CONFIG_FILE~ $PROJECT_APACHE_CONFIG_FILE
sed -e "s/{%hostname%}/$HOSTNAME/g" $PROJECT_APACHE_CONFIG_FILE > $PROJECT_APACHE_CONFIG_FILE~ && mv $PROJECT_APACHE_CONFIG_FILE~ $PROJECT_APACHE_CONFIG_FILE

echo "-> Apache configuration file created"

## register new configuration file to server side
echo "-> Register configuration file to server"
sudo bash -c "echo Include $PROJECT_APACHE_CONFIG_FILE >/etc/apache2/sites-available/$PROJECTNAME" || exit -1;

echo "-> Enabling site"
sudo a2ensite $PROJECTNAME || exit -1;
sudo service apache2 restart
