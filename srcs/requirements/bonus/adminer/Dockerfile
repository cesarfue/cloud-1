FROM debian:buster

RUN apt-get update && apt-get install -y \
wget \
php \ 
php-fpm

RUN mkdir -p /var/www/adminer && \
mkdir -p /run/php && \
wget "https://www.adminer.org/latest.php" -O /var/www/adminer/index.php

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/
RUN chown -R www-data:www-data /run/php && \
chown -R www-data:www-data /var/www/adminer
WORKDIR /var/www/adminer

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.3", "-F"]
