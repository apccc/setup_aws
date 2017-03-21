#!/bin/bash
if [ -z "$1" ];then
  echo "VPC Id not set!"
  exit 0
fi
if [ -z "$2" ];then
  echo "CIDR Block not set!"
  exit 0
fi
VPCID="$1"
CIDR="$2"
aws ec2 create-subnet --vpc-id "$VPCID" --cidr-block "$CIDR" --query 'Subnet.SubnetId' --output text
exit 0
