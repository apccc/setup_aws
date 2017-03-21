#!/bin/bash
source
AMI='ami-9eaa1cf6'
ITYPE='t2.micro'
INSTANCEID=`aws ec2 run-instances --image-id "$AMI" --count 1 --instance-type "$ITYPE" --key-name my-key --security-group-ids $securityGroupId --subnet-id $subnetId --associate-public-ip-address --query 'Instances[0].InstanceId' --output text`
exit 0
