# debian_php_dev_env
基于 Debian 的 PHP 开发环境容器，现被使用于 frame 框架的开发环境

### 环节说明
这个开发环境中含有以下组件
 * nginx
 * mariadb-server
 * redis-server
 * mongodb
 * beanstalkd
 * php-fpm
 * phpunit
 * inotify-tools
 * supervisor
 * wget
 * git
 * composer
 * vim
 * tmux
 * pip
 * mycli

### 使用方法：

sudo docker run --rm -ti -p 80:80 -p 3306:3306 --name debian_php_dev_env \
      -v {CODE_PATH}:/var/www/{PROJECT_NAME} \
      -v {NGINX_SERVER_CONFIG_FILE}:/etc/nginx/sites-enabled/default \
      -v {SUPERVISOR_CONFIG_FILE}:/etc/supervisor/conf.d/{CONFIG_NAME}.conf \
      kikiyao/debian_php_dev_env start

示例：

https://github.com/smarty-kiki/api_frame/blob/master/project/tool/start_development_server.sh
