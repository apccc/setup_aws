#!/bin/bash

source ~/setup_aws.conf.sh

echo "* Building Apache 2 Web Server for $COMPANY_NAME on $HOSTNAME"
echo "**********************************************"
echo "* Updating apt-get:"
sudo apt-get -qq update

echo "* Installing apache2:"
sudo apt-get -qq install -y apache2

echo "* Installing PHP with MySQL Support:"
sudo apt-get -qq install -y libapache2-mod-php5 php5-mysql php5-mysqlnd

#clear out existing sites-enabled files
if [ -d /etc/apache2/sites-enabled ];then
  echo " * Clearing existing files in sites-enabled:"
  sudo rm /etc/apache2/sites-enabled/*
fi

echo " * Setting up Extra Setup Conf File"
~/setup_aws/scripts/buildLocalServer/apache2Web/setupExtrasetup.conf.sh

echo " * Setting up The Default Site"
~/setup_aws/scripts/buildLocalServer/apache2Web/setupDefaultSite.sh

echo " * Setting up Any Additional Server Sites"
~/setup_aws/scripts/buildLocalServer/apache2Web/setupServerSites.sh

echo "* Enabling mod_ssl"
sudo a2enmod ssl

echo "* Enabling mod_rewrite"
sudo a2enmod rewrite

echo "* Restarting apache2:"
sudo /etc/init.d/apache2 restart

echo "* Showing current apache2 configuration:"
sudo apache2ctl -S
exit 0
