#!/bin/bash
source ~/setup_aws.conf.sh
if [ -z "$1" ];then
 ITYPE='t2.micro'
else
 ITYPE="$1"
fi
if [ -z "$2" ];then
 AMIID="$DEFAULT_AMI"
else
 AMIID="$2"
fi
VPC=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
SECGRP="setupaws-sec-${VPC}-grp"
SECGRPID=`~/setup_aws/scripts/tools/getSecurityGroupIdFromName.sh "$SECGRP"`
SUBNETID=`~/setup_aws/scripts/tools/getSubnetIDFromVPCID.sh "${VPC}"`
INSTANCEID=`aws ec2 run-instances --image-id "$AMIID" --count 1 --instance-type "$ITYPE" --key-name "$VPC" --security-group-ids "$SECGRPID" --subnet-id "$SUBNETID" --associate-public-ip-address --query 'Instances[0].InstanceId' --output text`
echo "$INSTANCEID"
exit 0
