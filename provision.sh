#!/bin/bash
set -e

#fix https://github.com/kikitux/yolo-php/issues/2
mkdir -p /vagrant/public

export DEBIAN_FRONTEND=noninteractive
PACKAGES=(apache2 mysql-server php5 php5-mysql php5-dev php-pear)

unset runAptInstall
for package in "${PACKAGES[@]}"; do
  isInstalled="`dpkg --get-selections ${package}`"
	if [[ ! "${isInstalled}" =~ "${package}" ]]; then
           runAptInstall="${package} ${runAptInstall}"
	fi
done

if [ "${runAptInstall}" ]; then
  sudo -E apt-get update
  sudo -E apt-get -f -y -q install --no-install-recommends ${runAptInstall}
fi

isxdebuginstalled="`find /usr/lib/php*/* -name xdebug.so`"
isxdebuginstalledrc="${?}"

if [ "${isxdebuginstalledrc}" -ne 0 ]; then
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
