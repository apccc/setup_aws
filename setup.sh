#!/bin/bash

if [ ! -f ~/setup_aws.conf.sh ];then
  echo "Copying the template settings file to ~/setup_aws.conf.sh"
  echo "Configure this file to your liking!"
  cp ~/setup_aws/settings/template.sh ~/setup_aws.conf.sh
fi
exit 0
