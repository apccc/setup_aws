#!/bin/bash

#sign certs from valid hostnames
for ZHOSTNAME in `sudo /opt/puppetlabs/bin/puppet cert list | egrep -oe '"[a-z0-9.-]*"' | egrep -oe '[a-z0-9.-]*'`;do
  INSTANCEID=`~/setup_aws/scripts/tools/getInstanceIdFromPrivateHostnameAndVPC.sh "$ZHOSTNAME"`
  if [ -z "$INSTANCEID" ];then
    echo "$ZHOSTNAME not found, skipping!"
    continue
  fi
  echo "Signing cert for instance $INSTANCEID with hostname $ZHOSTNAME"
  sudo /opt/puppetlabs/bin/puppet cert sign "$ZHOSTNAME"
done
exit 0
