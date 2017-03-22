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

sudo /opt/puppetlabs/bin/puppet module install puppetlabs-apache

exit 0
