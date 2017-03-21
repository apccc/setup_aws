#!/bin/bash
#get a subnet id from VPC ID
if [ -z "$1" ];then
  exit 1
fi
VPCID="$1"
aws ec2 describe-subnets --filters Name=vpc-id,Values="$VPCID" --query 'Subnets[*].{Name:SubnetId}' --output text
exit 0
