FROM debian:bookworm

RUN apt-get update && apt-get install -y \
wget \
php-fpm \
php-mysql \
php-mbstring \
php-xml \
php-zip

RUN mkdir -p /usr/src/phpmyadmin && \
wget -qO- "https://files.phpmyadmin.net/phpMyAdmin/5.2.3/phpMyAdmin-5.2.3-english.tar.gz" \
| tar -xz --strip-components=1 -C /usr/src/phpmyadmin

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/
COPY ./tools/phpmyadmin.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/phpmyadmin.sh

WORKDIR /var/www/phpmyadmin

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/phpmyadmin.sh"]

CMD ["/usr/sbin/php-fpm8.2", "-F"]
