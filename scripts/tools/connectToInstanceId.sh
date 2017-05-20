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

VPC=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
if [ -z "$VPC" ];then
  echo "VPC Could Not Be Obtained!"
  exit 1
fi

KEYF=~/setup_aws_keystore/${VPC}.pem
if [ ! -f "$KEYF" ];then
  echo "Key File Could Not Be Found!"
  exit 1
fi

echo "Connecting to $INSTANCEURL as $ZUSER"
ssh -i $KEYF ${ZUSER}@${INSTANCEURL}
echo "Disconnected from $INSTANCEURL"

exit 0
