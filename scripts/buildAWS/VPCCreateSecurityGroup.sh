#!/bin/bash
if [ -z "$1" ];then
  echo "VPC Id not set!"
  exit 1
fi
VPCID="$1"
SECURITYGROUPID=`aws ec2 create-security-group --group-name "setupaws-sec-${VPCID}-grp" --description "setupaws-sec-${VPCID}-grp" --vpc-id "$VPCID" --query 'GroupId' --output text`
MYIP=`~/setup_aws/scripts/tools/whatsmyip.sh`
aws ec2 authorize-security-group-ingress --group-id "$SECURITYGROUPID" --protocol tcp --port 22 --cidr "${MYIP}/32"
echo "$SECURITYGROUPID"
exit 0
