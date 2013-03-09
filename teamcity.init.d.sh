#!/bin/sh
# /etc/init.d/teamcity -  startup script for teamcity
# see: http://kogentadono.com/2012/05/11/part-1-setting-up-teamcity-for-php-ci-installing-tc

### BEGIN INIT INFO
# Provides:          teamcity-server
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO



export TEAMCITY_DATA_PATH="/opt/TeamCity/.BuildServer"

case $1 in
start)
start-stop-daemon --start  -c www-data --exec /opt/TeamCity/bin/teamcity-server.sh start
;;

stop)
start-stop-daemon --start -c www-data  --exec  /opt/TeamCity/bin/teamcity-server.sh stop
;;

esac

exit 0
