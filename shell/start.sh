#!/bin/bash

if  [ -n "$TIMEZONE" ]
then
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo $TIMEZONE >/etc/timezone
fi

service php7.4-fpm   start > /dev/null &
service nginx        start > /dev/null &
service mariadb      start > /dev/null &
service redis-server start > /dev/null &
service beanstalkd   start > /dev/null &
service supervisor   start > /dev/null &
service mongodb      start > /dev/null &

wait

date > /tmp/php_exception.log
date > /tmp/php_notice.log
date > /tmp/php_module.log

if [ -f "$AFTER_START_SHELL" ]
then
    /bin/bash $AFTER_START_SHELL
fi

tmuxinator init
