#!/bin/bash
if [ -z "$1" ];then
  echo "Instance Id Not Set!"
  exit 0
fi
INSTANCEID="$1"
echo "Setting up Apache2 Web Server on Instance $INSTANCEID"
INSTANCEURL=`~/setup_aws/scripts/tools/getInstanceURLFromId.sh $INSTANCEID`
if [ -z "$INSTANCEURL ];then
  echo "Instance URL Could Not Be Obtained!"
  exit 0
fi

source ~/setup_aws.conf.sh

#get the instance private hostname
PRIVATEHOSTNAME=`~/setup_aws/scripts/tools/getInstancePrivateHostnameFromId.sh "$INSTANCEID"`

#setup the puppet apache module
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-apache

#setup the puppet site file
F="/etc/puppetlabs/code/environments/production/manifests/site.pp"

#setup the apache entry for the file
if [[ `grep "$PRIVATEHOSTNAME" "$F" | grep 'apache' | wc -l` -lt 1 ]];then
  echo "node '${PRIVATEHOSTNAME}' { class { 'apache': }" | sudo tee -a "$F"
  echo " apache::vhost { 'example.com':" | sudo tee -a "$F"
  echo " port    => '80'," | sudo tee -a "$F"
  echo " docroot => '/var/www/html'" | sudo tee -a "$F"
  echo "}}" | sudo tee -a "$F"
fi

#make sure the default node entry is in place
X="node default {}"
if [[ `grep "$X" "$F" | wc -l` -lt 1 ]];then
  echo "$X" | sudo tee -a "$F"
fi

exit 0
