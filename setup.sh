#!/bin/bash

#setup the configuration file
F=~/setup_aws.conf.sh
if [ ! -f $F ];then
  echo " * Copying the template settings file to $F"
  echo " * Configure this file to your liking!"
  cp ~/setup_aws/settings/template.sh $F
  X=`tr -cd [:alnum:] < /dev/urandom | head -c 50`
  sed -i "s|MYSQL_ROOT_PW=''|MYSQL_ROOT_PW=='$X'|"  $F > /dev/null
  X=`tr -cd [:alnum:] < /dev/urandom | head -c 50`
  sed -i "s|MYSQL_WEB_USER_PASS=''|MYSQL_WEB_USER_PASS=='$X'|"  $F > /dev/null
  X=`tr -cd [:alnum:] < /dev/urandom | head -c 20`
  sed -i "s|SYSADMIN_INIT_PASS=''|SYSADMIN_INIT_PASS=='$X'|"  $F > /dev/null
  X=`tr -cd [:alnum:] < /dev/urandom | head -c 20`
  sed -i "s|PHPMYADMIN_FOLDER=''|PHPMYADMIN_FOLDER=='$X'|"  $F > /dev/null
else
  echo " * Configuration file is already in place ~/setup_aws.conf.sh"
fi

if [ ! -f ~/ec2-metadata ];then
  cd ~
  wget http://s3.amazonaws.com/ec2metadata/ec2-metadata
  chmod u+x ec2-metadata
else
  echo " * EC2 Metadata File in Place!"
fi

#install some packages
echo " * Updating apt-get"
sudo apt-get -qq update
echo " * Installing basic utilities."
sudo apt-get -qq install -y expect ntp pcregrep
echo " * Finished running setup."
exit 0
