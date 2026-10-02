FROM debian:buster

RUN apt-get update && apt-get -y install \
	wget \
  php \
	php-mysql \
	php-fpm \
  mariadb-client \
  php-redis

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

RUN mkdir /run/php
RUN chown -R www-data:www-data /run/php
COPY ./tools/wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress.sh

WORKDIR /var/www/html/

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]

CMD ["/usr/sbin/php-fpm7.3", "-F"]
