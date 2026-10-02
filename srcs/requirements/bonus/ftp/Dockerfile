FROM debian:buster

RUN apt-get update && apt-get install -y \
vsftpd

RUN mv /etc/vsftpd.conf /etc/vsftpd.conf.bak

COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/ftp.sh /usr/local/bin/ftp.sh
RUN chmod +x /usr/local/bin/ftp.sh

ENTRYPOINT ["/usr/local/bin/ftp.sh"]

CMD ["vsftpd", "/etc/vsftpd.conf"]
