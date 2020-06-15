#!/bin/bash

if  [ -n "$TIMEZONE" ]
then
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo $TIMEZONE >/etc/timezone
fi

service nginx start
service mysql start
service redis-server start
service php7.0-fpm start
service beanstalkd start
service supervisor start
service mongodb start

mysql -e "create database \`default\`"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password'"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'password'"

date > /tmp/php_exception.log
date > /tmp/php_notice.log

if [ -f "$AFTER_START_SHELL" ]
then
    /bin/bash $AFTER_START_SHELL
fi

tmuxinator init
