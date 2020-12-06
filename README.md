# environment variables
| environment name | default value | description |
| ---------------- | ----- | ----------- |
| TZ | Europe/Berlin | makes sure the time is correct: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones |
| MAX_EXECUTION_TIME | 60 | maximum php execution time |
| MAX_INPUT_TIME | 120 | |
| POST_MAX_SIZE | 16M | |
| UPLOAD_MAX_FILESIZE | 16M | |
| MEMORY_LIMIT | 512M | maximum amount of memory usage of php |
| CRON_INTERVAL | * * * * * | only if you have api modul enabled for background cronjobs: https://linuxhandbook.com/crontab/ |

All these values should be fine for a good running environment - but feel free to modify them as needed. Any changes are applied during container startup.

For timezones see: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
Information about cron: https://linuxhandbook.com/crontab/
All other variables are PHP variables for the TSI.

# volumes
- /var/www/html: TSI webpage files needs to be placed in here

# run container
This runs  the  tsi and mounts it to local port 80. If you want it on a different port change 80:80 to <yourport>:80.

***Online use:***
This container does not have any https functionality. Do not expose this port to the public as information like passwords are sent without encryption. For public usage please proxy it throught your webserver which maintains valid ssl certificates for https connection (like apache2, nginx, iis, ...).

```
docker run -d --name tsi -p 80:80 -v /root/tsi/web/:/var/www/html/ -e TZ=Europe/Berlin stefanruepp/docker-tsi:php-7.4
```

# build the image
```
docker build -t test-tsi -f Dockerfile .
```

# run it (from build above for debugging)
```
docker run -it --rm --name testtsi -p 80:80 -v /root/tsi/web/:/var/www/html/ -e TZ=Europe/Berlin test-tsi:latest bash
```
You need to copy the TSI php files into the mounted folder (in this example /root/tsi/web/).

# supported cache systems with this container
  - Memstatic (of course)
  - Filesystem (of course)
  - Apcu
  - Memcached
  - Predis
  - Riak
  - Ssdb

# not supported settings:
| Name | Issue |
| ---- | ----- |
| HTTPS redirect | https://github.com/MyUncleSam/docker-tsi/issues/3 |
| Clickjacking prevention | https://github.com/MyUncleSam/docker-tsi/issues/1 |

# Dockerfile.Alpine
Currently prepared to use it with alpine for a smaller image. But as there is not apache image, we cannot provide all functions. So it is ready but not finished.