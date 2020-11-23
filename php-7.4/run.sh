docker build -t test-tsi -f Dockerfile .
docker run -it --rm --name testtsi -p 80:80 -v /root/tsi/web/:/var/www/html/ -e TZ=Europe/Berlin test-tsi:latest bash
