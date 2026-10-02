FROM debian:buster

RUN apt-get update \
&& apt-get install -y mariadb-server \
mariadb-client \
&& mkdir -p /var/run/mysql \
&& chown -R mysql:mysql /var/run/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]

CMD ["mysqld", "--bind-address=0.0.0.0"]
