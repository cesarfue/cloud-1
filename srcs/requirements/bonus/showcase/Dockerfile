FROM debian:buster

RUN apt-get update \
&& apt-get install -y openssl nginx git \
&& mkdir -p /etc/nginx/ssl \
&& openssl req -x509 -nodes \
  -out /etc/nginx/ssl/bundle.crt \
  -keyout /etc/nginx/ssl/private.key \
  -subj "/C=FR/ST=RA/L=Lyon/O=42/OU=42/CN=cefuente.42.fr/UID=cefuente"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/run/nginx

RUN cd /var/www/html && git clone https://github.com/cesarfue/showcase
WORKDIR /var/www/html/showcase

EXPOSE 40000

CMD ["nginx", "-g", "daemon off;"]
