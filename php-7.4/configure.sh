#!/bin/bash

printf "(re)creating crontab file"
printf "# tsi crontab import file\n" > /opt/tsi/crontab-file.txt
printf "${CRON_INTERVAL} /opt/tsi/cron.sh > /dev/null 2>&1\n" >> /opt/tsi/crontab-file.txt
crontab -u www-data /opt/tsi/crontab-file.txt

printf "(re)creating cron.sh file"
printf "#!/bin/bash\n\n" > /opt/tsi/cron.sh
printf "if [ -f /var/www/html/inc/cron.php ]; then\n" >> /opt/tsi/cron.sh
printf "        echo 'Found cron.php file'\n" >> /opt/tsi/cron.sh
printf "        /usr/local/bin/php /var/www/html/inc/cron.php\n" >> /opt/tsi/cron.sh
printf "fi\n" >> /opt/tsi/cron.sh

printf "(re)creating php.ini for tsi"
printf "max_execution_time = ${MAX_EXECUTION_TIME}\n" > /usr/local/etc/php/conf.d/tsi-config.ini
printf "max_input_time = ${MAX_INPUT_TIME}\n" >> /usr/local/etc/php/conf.d/tsi-config.ini
printf "post_max_size = ${POST_MAX_SIZE}\n" >> /usr/local/etc/php/conf.d/tsi-config.ini
printf "upload_max_filesize = ${UPLOAD_MAX_FILESIZE}\n" >> /usr/local/etc/php/conf.d/tsi-config.ini
printf "allow_url_fopen = on\n" >> /usr/local/etc/php/conf.d/tsi-config.ini
printf "memory_limit = ${MEMORY_LIMIT}\n" >> /usr/local/etc/php/conf.d/tsi-config.ini

chmod a+rx /opt/tsi/*.sh
