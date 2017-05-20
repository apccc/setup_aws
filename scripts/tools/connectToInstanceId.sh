#!/bin/bash
#Connect to an Instance with Id
if [ -z "$1" ];then
  echo "Instance Id not set!"
  exit 1
fi
INSTANCEID="$1"
exit 0
