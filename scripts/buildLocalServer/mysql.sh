#!/bin/bash

source ~/setup_aws.conf.sh

echo "* Setting up MySQL Server for $COMPANY_NAME on $HOSTNAME"

~/setup_aws/scripts/buildLocalServer/mysql/installMySQLServer.exp

echo "* Done setting up MySQL Server"

exit 0
