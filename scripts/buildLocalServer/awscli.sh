#!/bin/bash
#install the awscli

#update apt
sudo apt-get update
#install Python
sudo apt-get install -y python python-pip

#install awscli
pip install awscli
exit 0
