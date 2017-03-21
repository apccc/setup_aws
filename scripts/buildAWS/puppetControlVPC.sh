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

if [ ! -f /opt/puppetlabs/bin/puppet ];then
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

  #set the memory footprint
  CONFF=/etc/default/puppetserver
  F=`grep '^JAVA_ARGS=' /etc/default/puppetserver`
  R='JAVA_ARGS="-Xms500m -Xmx500m -XX:MaxPermSize=256m"'
  $FR "$F" "$R" "$CONFF"

  #setup this controller as the Puppet Master CA
  ~/setup_aws/scripts/tools/expect/puppetMasterCASetup.exp
fi

  #set the memory footprint
  CONFF=/etc/default/puppetserver
  F=`grep '^JAVA_ARGS=' /etc/default/puppetserver`
  R='JAVA_ARGS="-Xms500m -Xmx500m -XX:MaxPermSize=256m"'
  $FR "$F" "$R" "$CONFF"


#install puppet on the remote systems
KEYFILE="~/setup_aws_keystore/${VPCID}.pem"
for INSTANCEID in `~/setup_aws/scripts/tools/getVPCInstancesIds.sh`;do
  INSTANCEURL=`~/setup_aws/scripts/tools/getInstanceURLFromId.sh $INSTANCEID`
  echo "Installing Puppet on $INSTANCEID at $INSTANCEURL as $CLIENT_ADMIN_USER using $KEYFILE"
  TASK="sudo apt-get update;sudo apt-get install -y puppet;"
  ~/setup_aws/scripts/tools/expect/performRemoteTask.exp "$CLIENT_ADMIN_USER" "$INSTANCEURL" "$KEYFILE" "$TASK"
  echo "Done Installing Puppet on $INSTANCEID at $INSTANCEURL as $CLIENT_ADMIN_USER using $KEYFILE"
done

#done
echo "Finished setting up puppet throughout the VPC"
exit 0
