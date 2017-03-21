#!/bin/bash
if [ -z "$1" ];then
  VPCID=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
else
  VPCID="$1"
fi
if [ -z "$1" ];then
  echo "VPC ID Not Set!"
  exit 1
fi

#setup puppet control throughout the controller's VPC

SECURITYGROUPID=`~/setup_aws/scripts/tools/getSecurityGroupIdFromName.sh "setupaws-sec-${VPCID}-grp"`
MYIP=`~/setup_aws/scripts/tools/whatsmyip.sh`
echo "Opening up port 8140 for this controller system."
aws ec2 authorize-security-group-ingress --group-id "$SECURITYGROUPID" --protocol tcp --port 8140 --cidr "${MYIP}/32"
exit 0
