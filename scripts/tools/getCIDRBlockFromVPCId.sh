#!/bin/bash
if [ -z "$1" ];then
 exit 1
fi
VPCID="$1"
aws ec2 describe-vpcs --vpc-ids "$VPCID" --query 'Vpcs[*].{Name:CidrBlock}' --output text
exit 0
