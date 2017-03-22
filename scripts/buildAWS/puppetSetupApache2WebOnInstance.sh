#!/bin/bash
if [ -z "$1" ];then
  echo "Instance Id Not Set!"
  exit 0
fi


echo "Setting up Apache2 Web Server on Instance"
echo ""
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-apache

exit 0
