#!/bin/bash
if [ -z "$1" ];then
  echo "VPC Id not set!"
  exit 0
fi
VPCID="$1"
INTERNETGATEWAYID=`aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text`
echo "Attaching Internet Gateway $INTERNETGATEWAYID to VPC with ID $VPCID"
aws ec2 attach-internet-gateway --internet-gateway-id "$INTERNETGATEWAYID" --vpc-id "$VPCID"
exit 0
