#!/bin/sh

service mysql start

mysql -uroot -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$SQL_ROOT_PASSWORD'; \
  FLUSH PRIVILEGES;"
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
mysql -root -e "CREATE USER '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
sleep 1
mysql -uroot -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD'; \
  FLUSH PRIVILEGES;"

service mysql stop

exec "$@"
