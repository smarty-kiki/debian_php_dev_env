FROM debian:bullseye

COPY ./config/apt_source.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install apt-utils -y && \
    apt-get upgrade -y && \
    apt-get install nginx -y && \
    apt-get install mariadb-server -y && \
    apt-get install redis-server -y && \
    apt-get install mongodb -y && \
    apt-get install beanstalkd -y
RUN apt-get install php7.4-fpm -y && \
    apt-get install php7.4-redis -y && \
    apt-get install php7.4-curl -y && \
    apt-get install php7.4-mysql -y && \
    apt-get install php7.4-mongodb -y && \
    apt-get install php7.4-xml -y && \
    apt-get install php7.4-mbstring -y && \
    apt-get install php7.4-yaml -y && \
    apt-get install php7.4-dev -y && \
    apt-get install php7.4-zip -y && \
    apt-get install php7.4-gd -y
RUN apt-get install phpunit -y && \
    apt-get install inotify-tools -y && \
    apt-get install wget -y && \
    apt-get install gnupg -y && \
    apt-get install zip -y && \
    apt-get install git -y && \
    apt-get install composer -y && \
    apt-get install vim -y && \
    apt-get install tmux -y && \
    apt-get install tmuxinator -y && \
    apt-get install supervisor -y && \
    apt-get install toilet -y
RUN apt-get install python3-pip -y && \
    pip install mycli

COPY ./shell/start.sh /bin/start
RUN chown root:root /bin/start && \
    chmod +x /bin/start

COPY ./config/bashrc /root/.bashrc
COPY ./config/tmux.conf /root/.tmux.conf

RUN mkdir -p /root/.tmuxinator
COPY ./config/tmuxinator_init.yml /root/.tmuxinator/init.yml

COPY ./config/nginx_config_xhgui /etc/nginx/sites-available/xhgui
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

COPY ./shell/config_init.sh /tmp/config_init.sh
RUN /bin/bash /tmp/config_init.sh

ENV LC_ALL C.UTF-8

EXPOSE 80 3306

CMD start
