# environment variables
- TZ=Europe/Berlin
- MAX_EXECUTION_TIME="60"
- MAX_INPUT_TIME="120"
- POST_MAX_SIZE="16M"
- UPLOAD_MAX_FILESIZE="16M"
- MEMORY_LIMIT="512M"
- CRON_INTERVAL="* * * * *"

# volumes
- /var/www/html: TSI webpage files needs to be placed in here

# build the image
```
docker build -t test-tsi -f Dockerfile .
```

# run it
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