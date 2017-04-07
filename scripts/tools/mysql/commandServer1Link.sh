#!/bin/bash

source ~/setup_aws.conf.sh

if [[ ! $1 ]];then
  echo '* mysql command server 1 link error - command not set'
  exit 0
fi

echo "$1" | mysql -u root -p$MYSQL_ROOT_PW --host "$MYSQL_1_HOST" 2>/dev/null
