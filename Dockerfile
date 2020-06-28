FROM debian:stretch

COPY ./config/apt_source.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install apt-utils -y && \
    apt-get upgrade -y && \
    apt-get install nginx -y && \
    apt-get install mariadb-server -y && \
    apt-get install redis-server -y && \
    apt-get install mongodb -y && \
    apt-get install beanstalkd -y && \
    apt-get install php7.4-fpm -y && \
    apt-get install php7.4-redis -y && \
    apt-get install php7.4-curl -y && \
    apt-get install php7.4-mysql -y && \
    apt-get install php7.4-mongodb -y && \
    apt-get install php7.4-xml -y && \
    apt-get install php7.4-mbstring -y && \
    apt-get install php7.4-yaml -y && \
    apt-get install php7.4-dev -y && \
    apt-get install php7.4-zip -y && \
    apt-get install phpunit -y && \
    apt-get install inotify-tools -y && \
    apt-get install wget -y && \
    apt-get install gnupg -y && \
    apt-get install zip -y && \
    apt-get install git -y && \
    apt-get install composer -y && \
    apt-get install vim -y && \
    apt-get install tmux -y && \
    apt-get install tmuxinator -y && \
    apt-get install supervisor -y

COPY ./shell/start.sh /bin/start
RUN chown root:root /bin/start && \
    chmod +x /bin/start

COPY ./config/bashrc /root/.bashrc
COPY ./config/tmux.conf /root/.tmux.conf

RUN mkdir -p /root/.tmuxinator
COPY ./config/tmuxinator_init.yml /root/.tmuxinator/init.yml

COPY ./config/ngxin_config_xhgui /etc/nginx/sites-available/xhgui
RUN ln -fs /etc/nginx/sites-available/xhgui /etc/nginx/sites-enabled/xhgui

RUN git -C /var/www/ clone https://github.com/laynefyc/xhgui-branch.git && \
    cd /var/www/xhgui-branch && \
    php install.php

RUN git -C /root/ clone https://github.com/tideways/php-xhprof-extension.git && \
    cd /root/php-xhprof-extension/ && \
    phpize && \
    ./configure && \
    make && make install

RUN echo extension=tideways_xhprof.so > /etc/php/7.4/mods-available/tideways.ini && \
    ln -fs /etc/php/7.4/mods-available/tideways.ini /etc/php/7.4/fpm/conf.d/20-tideways_xhprof.ini

RUN sed -i -e "s/^zlib\.output_compression\ = .*/zlib\.output_compression = \On/g" /etc/php/7.4/fpm/php.ini
RUN sed -i -e "s/^;max_input_vars\ = .*/max_input_vars\ =\ 20000/g" /etc/php/7.4/fpm/php.ini
RUN sed -i -e "s/^listen\ = .*/listen = \/var\/run\/php-fpm\.sock/g" /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i -e "s/^error_log\ = .*/error_log = \/var\/log\/php-fpm\.log/g" /etc/php/7.4/fpm/php-fpm.conf
RUN sed -i -e "s/^bind\-address/#bind\-address/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^#general_log/general_log/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^query_cache_limit\ .*/query_cache_limit\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^query_cache_size\ .*/query_cache_size\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^#BEANSTALKD_EXTRA=.*/BEANSTALKD_EXTRA=\"-z\ 524280\"/g" /etc/default/beanstalkd
RUN sed -i -e "s/'extension'.*$/'extension'\ =>\ 'tideways_xhprof',/g" /var/www/xhgui-branch/config/config.default.php

RUN touch /tmp/php_exception.log && \
    touch /tmp/php_notice.log && \
    touch /tmp/php_module.log && \
    chown www-data:www-data /tmp/php_exception.log && \
    chown www-data:www-data /tmp/php_notice.log && \
    chown www-data:www-data /tmp/php_module.log

ENV LC_ALL C.UTF-8

EXPOSE 80 3306

CMD start
