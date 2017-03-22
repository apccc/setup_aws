#!/bin/bash

#create an Apache 2 Web Instance

INSTANCEID=`~/setup_aws/scripts/buildAWS/InstanceCreate.sh`
if [ -z "$INSTANCEID" ];then
  echo "Instance Failed to be created"
  exit 1
fi

echo "Waiting 30 seconds for the Instance to finish booting up!"
sleep 30

echo "Ensuring Puppet Control Throughout the VPC"
~/setup_aws/scripts/buildAWS/puppetControlVPC.sh



exit 0
