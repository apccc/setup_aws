#!/bin/bash

source ~/setup_aws.conf.sh

echo " * Renewing SSL Certs"

$MY 'UPDATE `'"$SYSTEM_DATABASE"'`.`sites` SET `renew_SSL`="T" WHERE `SSL`="T"'

echo " * Setting up Default Site"
~/setup_aws/scripts/buildLocalServer/apache2Web/setupDefaultSite.sh

echo " * Setting up Server Sites"
~/setup_aws/scripts/buildLocalServer/apache2Web/setupServerSites.sh

$MY 'UPDATE `'"$SYSTEM_DATABASE"'`.`sites` SET `renew_SSL`="F" WHERE `renew_SSL`="T"'

exit 0
