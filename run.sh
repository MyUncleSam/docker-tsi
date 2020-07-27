docker build -t test-tsi -f Dockerfile .
docker run -it --rm --name testtsi --network="internal" --ip=172.20.18.18 -p 80:80 -v /root/tsi/web/:/var/www/html/ -e TZ=Europe/Berlin test-tsi:latest bash
