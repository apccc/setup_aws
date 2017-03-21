#!/bin/bash
#install the awscli

#update apt
sudo apt-get update
#install Python and pip
sudo apt-get install -y python python-pip
#upgrade pip
pip install --upgrade pip

#install awscli
pip install awscli
exit 0
