#!/bin/sh

find /var/www/phpmyadmin -mindepth 1 -maxdepth 1 ! -name config.inc.php -exec rm -rf {} +
cp -r /usr/src/phpmyadmin/. /var/www/phpmyadmin/

if [ ! -f /var/www/phpmyadmin/config.inc.php ]; then
  cat > /var/www/phpmyadmin/config.inc.php <<CONF
<?php
\$cfg['blowfish_secret'] = '$(php -r 'echo bin2hex(random_bytes(16));')';
\$cfg['Servers'][1]['host'] = 'mariadb';
\$cfg['Servers'][1]['auth_type'] = 'cookie';
\$cfg['TempDir'] = '/tmp';
CONF
fi

exec "$@"
