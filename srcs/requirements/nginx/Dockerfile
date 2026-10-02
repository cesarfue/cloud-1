FROM debian:buster

RUN apt-get update \
&& apt-get install -y nginx openssl \
&& mkdir -p /etc/nginx/ssl \
&& openssl req -x509 -nodes \
  -out /etc/nginx/ssl/bundle.crt \
  -keyout /etc/nginx/ssl/private.key \
  -subj "/C=FR/ST=RA/L=Lyon/O=42/OU=42/CN=cefuente.42.fr/UID=cefuente"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
