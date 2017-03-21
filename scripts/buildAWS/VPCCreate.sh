#!/bin/bash
if [ -z "$1" ];then
  CIDR="10.0.0.0/16"
else
  CIDR="$1"
fi
VPCID=`aws ec2 create-vpc --cidr-block "$CIDR" --query 'Vpc.VpcId' --output text`
echo "$VPCID"
exit 0
