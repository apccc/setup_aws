#!/bin/bash
#install the awscli

if [[ `which aws | wc -l` -gt 0 ]];then
  echo "aws is already installed";
  exit 0
fi

#update apt
if [ `whoami`=='root' ];then
  apt-get update
else
  sudo apt-get update
fi
#install Python and pip
if [ `whoami`=='root' ];then
  apt-get install -y python python-pip
else
  sudo apt-get install -y python python-pip
fi
#upgrade pip
pip install --upgrade pip

#install awscli
pip install awscli
exit 0
