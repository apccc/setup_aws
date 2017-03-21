#!/bin/bash
if [ -z "$1" ];then
 exit 1
fi
INSTANCEID="$1"
aws ec2 describe-instances --instance-ids "$INSTANCEID" --query 'Reservations[0].Instances[0].PublicDnsName' --output text
exit 0
