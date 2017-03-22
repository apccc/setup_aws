#!/bin/bash

#create an Apache 2 Web Instance

INSTANCEID=`~/setup_aws/scripts/buildAWS/InstanceCreate.sh`
if [ -z "$INSTANCEID" ];then
  echo "Instance Failed to be created"
  exit 1
fi


exit 0
