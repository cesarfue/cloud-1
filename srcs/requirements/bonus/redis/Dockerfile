FROM debian:buster

RUN apt-get update && apt-get -y install \
redis-server

EXPOSE 6379

RUN sed -i "s/^daemonize yes$/daemonize no/g" /etc/redis/redis.conf
RUN sed -i "s/^bind .*/bind 0.0.0.0/g" /etc/redis/redis.conf

CMD ["redis-server", "/etc/redis/redis.conf"]
