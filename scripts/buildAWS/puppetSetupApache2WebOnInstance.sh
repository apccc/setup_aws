#!/bin/bash
if [ -z "$1" ];then
  echo "Instance Id Not Set!"
  exit 0
fi
INSTANCEID="$1"
echo "Setting up Apache2 Web Server on Instance $INSTANCEID"
INSTANCEURL=`~/setup_aws/scripts/tools/getInstanceURLFromId.sh $INSTANCEID`
if [ -z "$INSTANCEURL" ];then
  echo "Instance URL Could Not Be Obtained!"
  exit 1
fi

source ~/setup_aws.conf.sh

#get the instance private hostname
PRIVATEHOSTNAME=`~/setup_aws/scripts/tools/getInstancePrivateHostnameFromId.sh "$INSTANCEID"`
if [ -z "$PRIVATEHOSTNAME" ];then
  echo "Private Hostname Could Not Be Obtained!"
  exit 0
fi

VPCID=`~/setup_aws/scripts/tools/getControllerVPCId.sh`
KEY=~/setup_aws_keystore/${VPCID}.pem

#setup the puppet apache module
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-apache

#setup the puppet site file
F="/etc/puppetlabs/code/environments/production/manifests/site.pp"
if [ ! -f "$F" ];then
  sudo touch "$F"
fi

#setup the apache entry for the file
if [[ `grep "$PRIVATEHOSTNAME" "$F" | grep 'apache' | wc -l` -lt 1 ]];then
  echo "node '${PRIVATEHOSTNAME}' { class { 'apache': }" | sudo tee -a "$F"
  echo " apache::vhost { 'example.com':" | sudo tee -a "$F"
  echo " port    => '80'," | sudo tee -a "$F"
  echo " docroot => '/var/www/html'" | sudo tee -a "$F"
  echo "}}" | sudo tee -a "$F"
fi

#make sure the default node entry is in place
X="node default {}"
if [[ `grep "$X" "$F" | wc -l` -lt 1 ]];then
  echo "$X" | sudo tee -a "$F"
fi

#perform the remote task
TASK="sudo puppet agent -t"
~/setup_aws/scripts/tools/expect/performRemoteTask.exp "$CLIENT_ADMIN_USER" "$INSTANCEURL" "$KEY" "$TASK"

#add firewall rules to open up Web traffic
SECURITYGROUPID=`~/setup_aws/scripts/tools/getSecurityGroupIdFromName.sh "setupaws-sec-${VPCID}-grp"`
aws ec2 authorize-security-group-ingress --group-id "$SECURITYGROUPID" --protocol tcp --port 80 --cidr "0.0.0.0/0"
aws ec2 authorize-security-group-ingress --group-id "$SECURITYGROUPID" --ip-permissions '[{"IpProtocol":"tcp","FromPort":80,"ToPort":80,"Ipv6Ranges":[{"CidrIpv6":"::/0"}]}]'
aws ec2 authorize-security-group-ingress --group-id "$SECURITYGROUPID" --protocol tcp --port 443 --cidr "0.0.0.0/0"
aws ec2 authorize-security-group-ingress --group-id "$SECURITYGROUPID" --ip-permissions '[{"IpProtocol":"tcp","FromPort":443,"ToPort":443,"Ipv6Ranges":[{"CidrIpv6":"::/0"}]}]'

echo "Done setting up Apache 2 Web Server on $INSTANCEID"
exit 0
