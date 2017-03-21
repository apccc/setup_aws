#!/bin/bash

if [ ! -f ~/setup_aws.conf.sh ];then
  echo "Copying the template settings file to ~/setup_aws.conf.sh"
  echo "Configure this file to your liking!"
  cp ~/setup_aws/settings/template.sh ~/setup_aws.conf.sh
else
  echo "Configuration file is already in place ~/setup_aws.conf.sh"
fi

if [ ! -f ~/ec2-metadata ];then
  cd ~
  wget http://s3.amazonaws.com/ec2metadata/ec2-metadata
  chmod u+x ec2-metadata
else
  echo "EC2 Metadata File in Place!"
fi
exit 0
