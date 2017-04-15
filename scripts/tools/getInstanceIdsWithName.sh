#!/bin/bash

if [ -z "$1" ];then
  exit 1
fi

#get the instance ids with a certain name
aws ec2 describe-instances --filters Name=tag:Name,Values="$1" --output text --query 'Reservations[*].Instances[*].{Name:InstanceId}' --output text
exit 0
