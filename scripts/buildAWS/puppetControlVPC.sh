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
  sudo $FR "$F" "$R" "$CONFF"

  #setup this controller as the Puppet Master CA
  ~/setup_aws/scripts/tools/expect/puppetMasterCASetup.exp
fi

if [[ `ps aux | grep puppetserver | grep java | wc -l` -lt 1 ]];then
  #start the local puppet server
  echo "Starting the puppet server! This may take a minute..."
  sudo service puppetserver restart

  #setup puppet to start on startup
  echo "Setting puppet to run at startup!"
  sudo /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true
fi

#install puppet on the remote systems
KEYFILE="~/setup_aws_keystore/${VPCID}.pem"
for INSTANCEID in `~/setup_aws/scripts/tools/getVPCInstancesIds.sh`;do
  INSTANCEURL=`~/setup_aws/scripts/tools/getInstanceURLFromId.sh $INSTANCEID`
  echo "Installing Puppet on $INSTANCEID at $INSTANCEURL as $CLIENT_ADMIN_USER using $KEYFILE"
  TASK='if [[ `cat /etc/hosts | grep puppet | wc -l` -lt 1 ]];then echo "'${MYIP}' puppet" | sudo tee -a /etc/hosts; fi;'
  TASK=$TASK'if [[ `which puppet | wc -l` -lt 1 ]];then sudo apt-get update;sudo apt-get install -y puppet; fi;'
  TASK=$TASK'if [[ `ps -ea | grep puppet | wc -l` -lt 1 ]];then sudo puppet resource service puppet ensure=running enable=true; fi;'
  ~/setup_aws/scripts/tools/expect/performRemoteTask.exp "$CLIENT_ADMIN_USER" "$INSTANCEURL" "$KEYFILE" "$TASK"
  echo "Done Installing Puppet on $INSTANCEID at $INSTANCEURL as $CLIENT_ADMIN_USER using $KEYFILE"
done

#done
echo "Finished setting up puppet throughout the VPC"
exit 0
