#!/bin/bash

#global vars
COMPANY_NAME=''
COMPANY_DOMAIN=''
COMPANY_ADMIN_SUBDOMAIN=''
COMPANY_SYSADMIN_EMAIL=''
SYSADMIN_INIT_PASS=''

#mid level vars
MYSQL_ROOT_PW=''
MYSQL_1_HOST=''
SYSTEM_DATABASE=''
MYSQL_WEB_USER=''
MYSQL_WEB_USER_PASS=''
PHPMYADMIN_FOLDER=''

#low level vars
DEFAULT_AMI='ami-9899c7f8'
CLIENT_ADMIN_USER='admin'
PUPPETAPTDEB='https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb'

#tools
FR=~/setup_aws/scripts/tools/findreplace.sh
MY=~/setup_aws/scripts/tools/mysql/commandServer1Link.sh
