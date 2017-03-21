#!/bin/bash
if [ -z "$1" ];then
  exit 1
fi
GROUPNAME="$1"
aws ec2 describe-security-groups --filters Name=group-name,Values="$GROUPNAME" --query 'SecurityGroups[*].{Name:GroupId}' --output text
exit 0
