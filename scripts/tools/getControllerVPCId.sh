#!/bin/bash
AWSKEYSTORE=~/setup_aws_keystore
if [ ! -d $AWSKEYSTORE ];then
  exit 1
fi
ls -1 $AWSKEYSTORE/ | head -n 1 | cut -d'.' -f1
exit 0
