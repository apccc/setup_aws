#!/bin/bash
if [ -z "$1" ];then
  echo "VPC Id not set!"
  exit 0
fi
VPCID="$1"
aws ec2 modify-vpc-attribute --vpc-id "$VPCID" --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id "$VPCID" --enable-dns-hostnames "{\"Value\":true}"
exit 1
