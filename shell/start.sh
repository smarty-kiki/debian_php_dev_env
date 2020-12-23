#!/bin/bash

if  [ -n "$TIMEZONE" ]
then
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo $TIMEZONE >/etc/timezone
fi

service php7.4-fpm start
service nginx start
service mariadb start
service redis-server start
service beanstalkd start
service supervisor start
service mongodb start

mysql -e "create database \`default\`;\
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password';\
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'password'"

date > /tmp/php_exception.log
date > /tmp/php_notice.log
date > /tmp/php_module.log

if [ -f "$AFTER_START_SHELL" ]
then
    /bin/bash $AFTER_START_SHELL
fi

tmuxinator init
