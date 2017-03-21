#!/bin/bash
#get the instance id from the VPC and Private Hostname

aws ec2 describe-instances --filters "Name=instance-type,Values=m1.small" "Name=availability-zone,Values=us-west-2c"

exit 0
