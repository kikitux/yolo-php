#!/bin/bash

#fix https://github.com/kikitux/yolo-php/issues/2
mkdir -p /vagrant/public

export DEBIAN_FRONTEND=noninteractive
PACKAGES=(apache2 mysql-server php5 php5-mysql php5-dev php-pear)

sudo -E apt-get update >/dev/null

for i in "${PACKAGES[@]}"; do
	if ! dpkg --get-selections | grep -q "^$i[[:space:]]*install$" >/dev/null; then
		sudo -E apt-get install -y -q --no-install-recommends "$i" >/dev/null
	fi
done

sudo -E apt-get -f -y -q install >/dev/null

if [ -n "$(find / -name 'xdebug.so' 2>/dev/null)" ]; then
	sudo pecl install -Z xdebug >/dev/null
fi

if ! grep -q 'xdebug.remote_enable=1' '/etc/php5/apache2/php.ini'; then
	sudo tee -a '/etc/php5/apache2/php.ini' >/dev/null <<-EOF
		zend_extension="$(find / -name 'xdebug.so' 2>/dev/null)"
		xdebug.remote_enable=1
		xdebug.remote_host=10.0.2.2
		xdebug.remote_port=9000
		xdebug.remote_handler=dbgp
		EOF
fi

if ! grep -q '<Directory /vagrant/public/>' '/etc/apache2/sites-enabled/000-default.conf'; then
	sudo tee '/etc/apache2/sites-enabled/000-default.conf' >/dev/null <<-EOF
		<Directory /vagrant/public/>
		    Options Indexes FollowSymLinks
		    AllowOverride All
		    Require all granted
		</Directory>
		<VirtualHost *:80>
		    DocumentRoot /vagrant/public
		    ErrorLog \${APACHE_LOG_DIR}/error.log
		    CustomLog \${APACHE_LOG_DIR}/access.log combined
		</VirtualHost>
		EOF
fi

sudo a2enmod rewrite >/dev/null
sudo service apache2 restart >/dev/null
