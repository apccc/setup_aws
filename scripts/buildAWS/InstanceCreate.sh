#!/bin/bash
source ~/setup_aws.conf.sh
AMI="$DEFAULT_AMI"
ITYPE='t2.micro'
VPC=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
SECGRP="setupaws-sec-${VPC}-grp"
INSTANCEID=`aws ec2 run-instances --image-id "$AMI" --count 1 --instance-type "$ITYPE" --key-name "$VPC" --security-group-ids $securityGroupId --subnet-id $subnetId --associate-public-ip-address --query 'Instances[0].InstanceId' --output text`
exit 0
