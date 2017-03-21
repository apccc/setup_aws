#!/bin/bash
if [ -z "$1" ];then
  VPCID=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
else
  VPCID="$1"
fi
if [ -z "$VPCID" ];then
  echo "VPC ID Not Set!"
  exit 1
fi

#get instances ids within the VPC
aws ec2 describe-instances --filters Name=vpc-id,Values="$VPCID" --query 'Reservations[*].Instances[*].{Name:InstanceId}' --output text
exit 0
