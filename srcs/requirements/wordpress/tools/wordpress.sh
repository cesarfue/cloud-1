#!/bin/sh

if [ ! -f ./wp-config.php ]; then
  wp core download --locale=en_GB --allow-root

  wp config create \
    --dbname=$SQL_DATABASE \
    --dbuser=$SQL_USER \
    --dbpass=$SQL_PASSWORD \
    --dbhost=mariadb \
    --path=/var/www/html/ \
    --allow-root

  wp core install \
    --url=$WP_URL \
    --title=$WP_TITLE \
    --admin_user=$WP_ADMIN_USER \
    --admin_email=$WP_ADMIN_EMAIL \
    --admin_password=$WP_ADMIN_PASS \
    --path=/var/www/html/ \
    --allow-root

  wp user create \
    $WP_USER \
    $WP_EMAIL \
    --user_pass=$WP_PASS \
    --path=/var/www/html/ \
    --allow-root

  wp config set WP_REDIS_HOST redis --allow-root
  wp config set WP_REDIS_PORT 6379 --raw --allow-root
  wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
  wp config set WP_REDIS_CLIENT phpredis --allow-root
  wp plugin install redis-cache --activate --allow-root
  wp redis enable --allow-root /var/www/html/
fi

exec "$@"
