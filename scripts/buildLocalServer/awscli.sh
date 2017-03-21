#!/bin/bash
#install the awscli

if [[ `which aws | wc -l` -gt 0 ]];then
  echo "aws is already installed";
  exit 0
fi

#update apt
sudo apt-get update
#install Python and pip
sudo apt-get install -y python python-pip
#upgrade pip
pip install --upgrade pip

#install awscli
pip install awscli
exit 0
