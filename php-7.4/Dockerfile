FROM php:7.4.13-apache

# some environment variables
ENV TZ="Europe/Berlin"
ENV MAX_EXECUTION_TIME="60"
ENV MAX_INPUT_TIME="120"
ENV POST_MAX_SIZE="16M"
ENV UPLOAD_MAX_FILESIZE="16M"
ENV MEMORY_LIMIT="512M"
ENV CRON_INTERVAL="* * * * *"

# install dependencies
# set timezone and link extensions directory
# create tsi base folder
RUN /usr/bin/apt-get update \
    && /usr/bin/apt-get install -y wget libzip-dev libcurl4-openssl-dev libpng-dev unzip tzdata cron libfreetype6-dev libjpeg-dev libpng-dev memcached libmemcached-dev \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && ln -s $(php-config --extension-dir --extension-dir) /php_ext \
    && mkdir /opt/tsi

# copy files
ADD ./start.sh /opt/tsi/start.sh
ADD ./configure.sh /opt/tsi/configure.sh

# there is a bug by gd configuration of freetype, it needs to be installed at first to be able to enable freetype
# https://github.com/docker-library/php/issues/926#issuecomment-567230723
# also install ioncube, some extensions andenable mod rewrite
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) gd curl zip bcmath pdo pdo_mysql opcache \
    && wget -O /tmp/ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvzf /tmp/ioncube.tar.gz --directory=/tmp \
    && cp /tmp/ioncube/ioncube_loader_lin_7.4.so /php_ext/ioncube.so \
    && PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) \
    && echo "zend_extension = $PHP_EXT_DIR/ioncube.so" > /usr/local/etc/php/conf.d/_ioncube.ini \
    && rm -rf /tmp/* \
    && printf '\n' | pecl install apcu \
    && printf '\n' | pecl install memcached \
    && printf '\n' | pecl install redis \
    && printf '\n' | pecl install mongodb \
    && PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/memcached.so" > /usr/local/etc/php/conf.d/cache-extensions.ini \
    && PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/apcu.so" >> /usr/local/etc/php/conf.d/cache-extensions.ini \
    && PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/redis.so" >> /usr/local/etc/php/conf.d/cache-extensions.ini \
    && PHP_EXT_DIR=$(php-config --extension-dir --extension-dir) && echo "extension=$PHP_EXT_DIR/mongodb.so" >> /usr/local/etc/php/conf.d/cache-extensions.ini \
    && /usr/sbin/a2enmod rewrite

# cleanup
RUN rm /php_ext \
    && rm -rf /tmp/* \
    && apt-get remove -y wget unzip \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && apt-get autoremove -y \
    && chmod a+rx /opt/tsi/*.sh

# volumes
VOLUME ["/var/www/html", "/var/www/html"]

# entrypoint
CMD ["/opt/tsi/start.sh"]
