#!/bin/bash
if [ -z "$1" ];then
  exit 1
fi
ZHOSTNAME="$1"

if [ -z "$2" ];then
  VPCID=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
else
  VPCID="$2"
fi
if [ -z "$VPCID" ];then
  exit 1
fi
#get the instance id from the VPC and Private Hostname

aws ec2 describe-instances --filters "Name=instance-type,Values=m1.small" "Name=availability-zone,Values=us-west-2c"

exit 0
