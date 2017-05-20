#!/bin/bash
#Connect to an Instance with Id
if [ -z "$1" ];then
  echo "Instance Id not set!"
  exit 1
fi
INSTANCEID="$1"
if [ -z "$2" ];then
 ZUSER="admin"
else
 ZUSER="$2"
fi

INSTANCEURL=`~/setup_aws/scripts/tools/getInstanceURLFromId.sh "$INSTANCEID"`

if [ -z "$INSTANCEURL" ];then
  echo "Instance URL Could Not Be Obtained!"
  exit 1
fi

exit 0
