#!/bin/bash

ROOT_DIR="$(cd "$(dirname $0)" && pwd)"

sed -i -e "s/^zlib\.output_compression\ = .*/zlib\.output_compression = \On/g" /etc/php/7.4/fpm/php.ini
sed -i -e "s/^;max_input_vars\ = .*/max_input_vars\ =\ 20000/g" /etc/php/7.4/fpm/php.ini
sed -i -e "s/^listen\ = .*/listen = \/var\/run\/php-fpm\.sock/g" /etc/php/7.4/fpm/pool.d/www.conf
sed -i -e "s/^error_log\ = .*/error_log = \/var\/log\/php-fpm\.log/g" /etc/php/7.4/fpm/php-fpm.conf
sed -i -e "s/^bind\-address/#bind\-address/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^#general_log/general_log/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^query_cache_limit\ .*/query_cache_limit\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^query_cache_size\ .*/query_cache_size\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^#slow_query_log_file\ .*/slow_query_log_file\ =\ \/var\/log\/mysql\/slow\.log/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "/^slow_query_log_file/a\slow_query_log\ =\ on" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^#long_query_time\ .*/long_query_time\ =\ 0\.5/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^#log_slow_verbosity\ .*/log_slow_verbosity\ =\ query_plan\,explain/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^#log-queries-not-using-indexes.*/log-queries-not-using-indexes\ =\ on/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^#log_error/log_error/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e "s/^skip_log_error/^#skip_log_error/g" /etc/mysql/mariadb.conf.d/50-mysqld_safe.cnf
sed -i -e "s/^syslog/^#syslog/g" /etc/mysql/mariadb.conf.d/50-mysqld_safe.cnf
sed -i -e "s/^#BEANSTALKD_EXTRA=.*/BEANSTALKD_EXTRA=\"-z\ 524280\"/g" /etc/default/beanstalkd
sed -i -e "s/'extension'.*$/'extension'\ =>\ 'tideways_xhprof',/g" /var/www/xhgui-branch/config/config.default.php
