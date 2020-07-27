# environment variables
- TZ=Europe/Berlin
- MAX_EXECUTION_TIME="60"
- MAX_INPUT_TIME="120"
- POST_MAX_SIZE="16M"
- UPLOAD_MAX_FILESIZE="16M"
- MEMORY_LIMIT="512M"

# volumes
- /var/www/html: TSI webpage files needs to be placed in here

# run it
> docker build -t test-tsi -f Dockerfile .
>
> docker run -it --rm --name testtsi -p 80:80 -v /root/tsi/web/:/var/www/html/ -e TZ=Europe/Berlin test-tsi:latest bash
