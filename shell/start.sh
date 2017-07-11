#!/bin/bash

service nginx start
service mysql start
service redis-server start
service beanstalkd start
service php7.0-fpm start
service beanstalkd start
service supervisor start

mysql -e "create database \`default\`"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'password'"

tail -n 100 -f /var/log/nginx/access.log /var/log/nginx/error.log /var/log/php7.0-fpm.log /var/log/mysql/error.log /var/log/redis/redis-server.log
