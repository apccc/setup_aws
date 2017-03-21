#!/bin/bash
if [ -z "$1" ];then
  echo "Key Name Not Set!"
  exit 1
fi
KEYNAME="$1"
KEYSTOREDIR=~/setup_aws_keystore
if [ ! -d $KEYSTOREDIR ];then
  mkdir $KEYSTOREDIR
fi
F=${KEYSTOREDIR}/${KEYNAME}.pem
if [ -f $F ];then
  echo "Key already exists $F"
  exit 0
fi
aws ec2 create-key-pair --key-name "$KEYNAME" --query 'KeyMaterial' --output text > $F
chmod 400 $F
exit 0
