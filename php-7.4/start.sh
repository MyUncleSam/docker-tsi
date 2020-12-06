#!/bin/bash
chown -R www-data: /var/www/html
/opt/tsi/configure.sh
cron &
apache2-foreground
chmod u+x /opt/tsi/start.sh