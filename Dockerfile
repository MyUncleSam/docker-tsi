FROM php:7.4-apache

# some environment variables
ENV TZ="Europe/Berlin"
ENV MAX_EXECUTION_TIME="60"
ENV MAX_INPUT_TIME="120"
ENV POST_MAX_SIZE="16M"
ENV UPLOAD_MAX_FILESIZE="16M"
ENV MEMORY_LIMIT="512M"
ENV CRON_INTERVAL="* * * * *"

# install dependencies
RUN /usr/bin/apt-get update
RUN /usr/bin/apt-get install -y wget libzip-dev libcurl4-openssl-dev libpng-dev unzip tzdata cron libfreetype6-dev libjpeg-dev libpng-dev memcached libmemcached-dev

# set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# link extensions directory
RUN ln -s $(php-config --extension-dir --extension-dir) /php_ext

# there is a bug by gd configuration of freetype, it needs to be installed at first to be able to enable freetype
# https://github.com/docker-library/php/issues/926#issuecomment-567230723
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-configure zip

RUN docker-php-ext-install -j$(nproc) gd curl zip bcmath pdo pdo_mysql opcache

# installing ioncube
RUN wget -O /tmp/ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
RUN tar -xvzf /tmp/ioncube.tar.gz --directory=/tmp

# ioncube needs to be loaded as first plugin, as they are loaded in alphabetical order, we need to make it the first in line
RUN cp /tmp/ioncube/ioncube_loader_lin_7.4.so /php_ext/ioncube.so
RUN PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "zend_extension = $PHP_EXT_DIR/ioncube.so" > /usr/local/etc/php/conf.d/_ioncube.ini

# installing and enabling cache extensions
RUN printf '\n' | pecl install apcu
RUN printf '\n' | pecl install memcached
RUN printf '\n' | pecl install redis
RUN printf '\n' | pecl install mongodb

RUN PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/memcached.so" > /usr/local/etc/php/conf.d/cache-extensions.ini
RUN PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/apcu.so" >> /usr/local/etc/php/conf.d/cache-extensions.ini
RUN PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/redis.so" >> /usr/local/etc/php/conf.d/cache-extensions.ini
RUN PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/mongodb.so" >> /usr/local/etc/php/conf.d/cache-extensions.ini

# enabling apache modules
RUN /usr/sbin/a2enmod rewrite

# php configuration
RUN echo "max_execution_time = ${MAX_EXECUTION_TIME}" > /usr/local/etc/php/conf.d/tsi-config.ini
RUN echo "max_input_time = ${MAX_INPUT_TIME}" >> /usr/local/etc/php/conf.d/tsi-config.ini
RUN echo "post_max_size = ${POST_MAX_SIZE}" >> /usr/local/etc/php/conf.d/tsi-config.ini
RUN echo "upload_max_filesize = ${UPLOAD_MAX_FILESIZE}" >> /usr/local/etc/php/conf.d/tsi-config.ini
RUN echo "allow_url_fopen = on" >> /usr/local/etc/php/conf.d/tsi-config.ini
RUN echo "memory_limit = ${MEMORY_LIMIT}" >> /usr/local/etc/php/conf.d/tsi-config.ini

# prepare tsi folder
RUN mkdir /opt/tsi

# create cronjob file to only execute if cron.php is available
RUN echo "#!/bin/bash" > /opt/tsi/cron.sh
RUN echo "" >> /opt/tsi/cron.sh
RUN echo "if [ -f /var/www/html/inc/cron.php ]; then" >> /opt/tsi/cron.sh
RUN echo "        echo 'Found cron.php file'" >> /opt/tsi/cron.sh
RUN echo "        /usr/local/bin/php /var/www/html/inc/cron.php" >> /opt/tsi/cron.sh
RUN echo "fi" >> /opt/tsi/cron.sh
RUN chmod a+r /opt/tsi/cron.sh
RUN chmod a+x /opt/tsi/cron.sh

# add cronjob which is executed every minute
RUN echo "# tsi crontab import file" > /opt/tsi/crontab-file.txt
RUN echo "${CRON_INTERVAL} /opt/tsi/cron.sh > /dev/null 2>&1" >> /opt/tsi/crontab-file.txt
RUN crontab -u www-data /opt/tsi/crontab-file.txt

# custom startscript to modify permissions
RUN echo "#!/bin/bash" > /opt/tsi/start.sh
RUN echo "chown -c -R www-data: /var/www/html" >> /opt/tsi/start.sh
RUN echo "cron &" >> /opt/tsi/start.sh
RUN echo "apache2-foreground" >> /opt/tsi/start.sh
RUN chmod u+x /opt/tsi/start.sh

# cleanup
RUN rm /php_ext
RUN rm -rf /tmp/*
RUN rm /opt/tsi/crontab-file.txt
RUN apt-get remove -y wget unzip
RUN apt-get autoclean -y
RUN apt-get clean -y
RUN apt-get autoremove -y

# volumes
VOLUME ["/var/www/html", "/var/www/html"]

# entrypoint
CMD ["/opt/tsi/start.sh"]
