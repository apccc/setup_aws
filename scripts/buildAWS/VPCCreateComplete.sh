#!/bin/bash
#create a complete VPC
if [ -z "$1" ];then
  CIDR="10.0.0.0/16"
else
  CIDR="$1"
fi

#create the VPC
VPCID=`~/setup_aws/scripts/buildAWS/VPCCreate.sh "$CIDR"`
if [ -z "$VPCID" ];then
  echo "Could not create VPC!"
  exit 1
fi
echo "VPC $VPCID created!"

#enable DNS in the VPC
~/setup_aws/scripts/buildAWS/VPCEnableDNS.sh "$VPCID"

#create a gateway
INTERNETGATEWAYID=`~/setup_aws/scripts/buildAWS/VPCCreateGateway.sh`
echo "Internet Gatway $INTERNETGATEWAYID created!"

#create the/a subnet
SUBNETID=`~/setup_aws/scripts/buildAWS/VPCCreateSubnet.sh "$VPCID" "$CIDR"`
echo "Subnet $SUBNETID created!"

#create routing table and route the traffic to the gateway
echo "Setting up Routing Table for Routing external traffic in the VPC Subnet to the Internet Gateway!"
~/setup_aws/scripts/buildAWS/VPCRouteExternalTrafficToGateway.sh "$VPCID" "$SUBNETID" "$INTERNETGATEWAYID"

#create the security group
SECURITYGROUPID=`~/setup_aws/scripts/buildAWS/VPCCreateSecurityGroup.sh`
echo "Security Group $SECURITYGROUPID created!"

#create the controller key to the VPC
echo "Creating controller PEM key to the VPC!"
~/setup_aws/scripts/buildAWS/PEMKeyCreateFromName.sh "$VPCID"

exit 0
