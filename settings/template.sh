#!/bin/bash

#global vars
COMPANY_NAME='Example Company'
COMPANY_DOMAIN='example.com'
COMPANY_ADMIN_SUBDOMAIN='subdomainexample'
COMPANY_SYSADMIN_EMAIL='me@example.com'
SYSADMIN_INIT_PASS='putYourPasswordHere'

#mid level vars
MYSQL_ROOT_PW=''
MYSQL_1_HOST='localhost'
SYSTEM_DATABASE='setup_aws'
MYSQL_WEB_USER='mywebadmin'
MYSQL_WEB_USER_PASS=''
PHPMYADMIN_FOLDER=''
WHITELISTEDIPS=''

#low level vars
DEFAULT_AMI='ami-9899c7f8'
CLIENT_ADMIN_USER='admin'
PUPPETAPTDEB='https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb'

#tools
FR=~/setup_aws/scripts/tools/findreplace.sh
MY=~/setup_aws/scripts/tools/mysql/commandServer1Link.sh
AP=~/setup_aws/scripts/tools/appendFileOnce.sh
AC=~/setup_aws/scripts/tools/appendCronOnce.sh
