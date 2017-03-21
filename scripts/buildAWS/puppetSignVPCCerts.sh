#!/bin/bash

#sign certs from valid hostnames
for ZHOSTNAME in `sudo /opt/puppetlabs/bin/puppet cert list | egrep -oe '"[a-z0-9.-]*"' | egrep -oe '[a-z0-9.-]*'`;do
  echo "$ZHOSTNAME"
done
