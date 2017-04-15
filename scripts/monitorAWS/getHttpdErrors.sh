#!/bin/bash

#get the last errors from httpd servers

if [ -z "$1" ];then
  echo "EC2 Servers' Name Not Set!"
  exit 1
fi

if [ -z "$2" ];then
  echo "Key File Not Set!"
  exit 1
fi

SERVERNAME=$1
KEYFILE=$2

if [ -z "$3" ];then
  LINES=5
else
  LINES=$3
fi

if [ -z "$4" ];then
  SERVERUSER="ec2-user"
else
  SERVERUSER="$4"
fi

for INSTANCEID in `~/setup_aws/scripts/tools/getInstanceIdsWithName.sh "$SERVERNAME"`;do
  if [ -z "$INSTANCEID" ];then
    continue
  fi
  echo "INSTANCEID: $INSTANCEID"
  INSTANCEURL=`~/setup_aws/scripts/tools/getInstanceURLFromId.sh "$INSTANCEID"`
  if [ -z "$INSTANCEURL" ];then
    continue
  fi
  echo "INSTANCEURL: $INSTANCEURL"
#~/setup_aws/scripts/tools/expect/performRemoteTask.exp\
  # "$SERVERUSER" "$SERVERURL" "$KEYFILE" "tail -n $LINES /var/log/httpd/error_log"
done
exit 0
