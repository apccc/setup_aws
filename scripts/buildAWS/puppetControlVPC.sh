#!/bin/bash
if [ -z "$1" ];then
  VPCID=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
else
  VPCID="$1"
fi
if [ -z "$VPCID" ];then
  echo "VPC ID Not Set!"
  exit 1
fi

#setup puppet control throughout the controller's VPC
echo "Setting up Puppet throughout the VPC $VPCID"

source ~/setup_aws.conf.sh

#ensure the VPC port is open to puppet control from the puppet master server
SECURITYGROUPID=`~/setup_aws/scripts/tools/getSecurityGroupIdFromName.sh "setupaws-sec-${VPCID}-grp"`
MYIP=`~/setup_aws/scripts/tools/whatsmyip.sh`
echo "Opening up port 8140 for $MYIP in security group $SECURITYGROUPID."
aws ec2 authorize-security-group-ingress --group-id "$SECURITYGROUPID" --protocol tcp --port 8140 --cidr "${MYIP}/32"

#get the puppet apt deb file
cd /tmp
echo "Retrieving $PUPPETAPTDEB"
wget $PUPPETAPTDEB
FILE=`ls -1 | grep 'puppet' | grep '.deb'`
if [ -z "$FILE" ];then
  echo "File could not be obtained!"
  exit 1
fi
echo "Found puppet deb file $FILE"
sudo dpkg -i "$FILE"
sudo apt-get update
if [ -f "$FILE" ];then
  rm "$FILE"
fi
#install the puppet server
sudo apt-get install -y puppetserver
exit 0
