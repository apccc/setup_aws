#!/bin/bash
if [ -z "$1" ];then
  echo "VPC Id not set!"
  exit 0
fi
if [ -z "$2" ];then
  echo "Subnet Id not set!"
  exit 0
fi
if [ -z "$3" ];then
  echo "Gateway Id not set!"
  exit 0
fi
VPCID="$1"
SUBNETID="$1"
GATEWAYID="$1"
ROUTETABLEID=`aws ec2 create-route-table --vpc-id "$VPCID" --query 'RouteTable.RouteTableId' --output text`
aws ec2 associate-route-table --route-table-id "$ROUTETABLEID" --subnet-id "$SUBNETID"
aws ec2 create-route --route-table-id "$ROUTETABLEID" --destination-cidr-block 0.0.0.0/0 --gateway-id "$GATEWAYID"
echo "$ROUTETABLEID"
exit 0
