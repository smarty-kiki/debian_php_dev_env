# debian_php_dev_env
基于 Debian 的 PHP 开发环境容器

### 环节说明
这个开发环境中含有以下组件
 * nginx
 * mariadb-server
 * redis-server
 * mongodb
 * beanstalkd
 * php-fpm
 * php-redis
 * php-curl
 * php-mysql
 * php-mongodb
 * php-dom
 * php-mbstring
 * php-yaml
 * supervisor

### 使用方法：

sudo docker run --rm -ti -p 80:80 -p 3306:3306 --name debian_php_dev_env \
      -v {CODE_PATH}:/var/www/{PROJECT_NAME} \
      -v {NGINX_SERVER_CONFIG_FILE}:/etc/nginx/sites-enabled/default \
      -v {SUPERVISOR_CONFIG_FILE}:/etc/supervisor/conf.d/{CONFIG_NAME}.conf \
      kikiyao/debian_php_dev_env start

示例：

https://github.com/smarty-kiki/micro_api_frame/blob/master/project/tool/start_dev_server.sh
