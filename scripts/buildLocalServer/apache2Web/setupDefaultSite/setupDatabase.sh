#!/bin/bash

source ~/setup_aws.conf.sh

echo " * Setting up database for default Web site"

#create the database, if necessary
X="CREATE DATABASE IF NOT EXISTS $SYSTEM_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
$MY "$X"

#create the user, if necessary
if [[ `$MY "SELECT User FROM mysql.user WHERE User LIKE '${MYSQL_WEB_USER}';" | tail -n 2 | wc -l` -lt 1 ]];then
  #create the web user
  X="CREATE USER '${MYSQL_WEB_USER}'@'%' IDENTIFIED BY '${MYSQL_WEB_USER_PASS}';"
  $MY "$X"

  X="GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, FILE, INDEX, ALTER, CREATE TEMPORARY TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE "
  X=$X"ON *.* TO '${MYSQL_WEB_USER}'@'%' IDENTIFIED BY '${MYSQL_WEB_USER_PASS}';"
  $MY "$X"
fi

#create the user table, if this does not exist
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'users';" | tail -n +2 | wc -l` -lt 1 ]];then
  X="CREATE TABLE IF NOT EXISTS ${SYSTEM_DATABASE}.users ("
  X=$X'`id` bigint(10) NOT NULL,'
  X=$X'`first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`password` varbinary(512) NOT NULL,'
  X=$X'`nonce` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`url` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`active` varchar(2) COLLATE utf8_unicode_ci NOT NULL DEFAULT "F",'
  X=$X'`is_admin` enum("T","F") COLLATE utf8_unicode_ci NOT NULL DEFAULT "F",'
  X=$X'`variables` TEXT NOT NULL,'
  X=$X'`timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP'
  X=$X') ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X="ALTER TABLE ${SYSTEM_DATABASE}.users ADD PRIMARY KEY (id), ADD UNIQUE KEY email (email);"
  $MY "$X"

  X="ALTER TABLE ${SYSTEM_DATABASE}.users MODIFY id bigint(20) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;"
  $MY "$X"

  NONCE=`tr -cd [:alnum:] < /dev/urandom | head -c 250`
  PW_HASH=`echo -n "${SYSADMIN_INIT_PASS}${NONCE}" | sha512sum | cut -d' ' -f1`

  X='INSERT INTO `'"${SYSTEM_DATABASE}"'`.`users` '
  X=$X'(`first_name`,`last_name`,`email`,`password`,`nonce`,`active`,`is_admin`) '
  X=$X"VALUES ('System','Administrator','${COMPANY_SYSADMIN_EMAIL}','${PW_HASH}','${NONCE}','T','T');"
  $MY "$X"
fi

#create the login tries table, if this does not exist
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'login_tries';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`login_tries` ('
  X=$X'`id` bigint(10) NOT NULL,'
  X=$X'`email` varchar(200) COLLATE utf8_unicode_ci NOT NULL,'
  X=$X'`ip` varchar(50) COLLATE utf8_unicode_ci NOT NULL,'
  X=$X'`timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
  X=$X') ENGINE=InnoDB AUTO_INCREMENT=155051 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`login_tries` ADD PRIMARY KEY (`id`), ADD KEY `ip` (`ip`), ADD KEY `timestamp` (`timestamp`), ADD KEY `email` (`email`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`login_tries` MODIFY `id` bigint(10) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;'
  $MY "$X"
fi

#create the whitelisted ips
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'whitelisted_ips';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`whitelisted_ips` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`ip` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`whitelisted_ips` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `ip` (`ip`), ADD KEY `timestamp` (`timestamp`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`whitelisted_ips` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"

  for ZIP in `echo "$WHITELISTEDIPS" | tr ' ' '\n'`;do
    echo " * Whitelisting IP $ZIP"
    X='INSERT INTO `'"${SYSTEM_DATABASE}"'`.`whitelisted_ips` (`ip`) VALUES ("'"$ZIP"'");'
    $MY "$X"
 done
fi


#create the CSS table
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'css';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`css` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`description` text COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`sheet` longtext COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`ord` int(10) NOT NULL DEFAULT "0",'
  X=$X'`whitelisted_ips` TEXT NOT NULL,'
  X=$X'`lastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`css` ADD PRIMARY KEY (`id`), ADD KEY `ord` (`ord`), ADD KEY `lastUpdated` (`lastUpdated`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`css` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"
fi


#create the JS table
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'js';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`js` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`description` text COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`script` longtext COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`ord` int(10) NOT NULL DEFAULT "0",'
  X=$X'`whitelisted_ips` TEXT NOT NULL,'
  X=$X'`lastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`js` ADD PRIMARY KEY (`id`), ADD KEY `ord` (`ord`), ADD KEY `lastUpdated` (`lastUpdated`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`js` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"
fi


#create the documentation table
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'documentation';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`documentation` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`category` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`documentation` ADD PRIMARY KEY (`id`), ADD KEY `category` (`category`), ADD KEY `updated` (`updated`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`documentation` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"
fi


#create the sites table
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'sites';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`sites` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`subdomain` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`aliases` TEXT NOT NULL,'
  X=$X'`SSL` ENUM("T","F") NOT NULL DEFAULT "T",'
  X=$X'`renew_SSL` enum("T","F") COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "F",'
  X=$X'`AllowOverride` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "None",'
  X=$X'`cronjobs` TEXT NOT NULL,'
  X=$X'`rewrites` TEXT NOT NULL,'
  X=$X'`virtualhost_extras` TEXT NOT NULL,'
  X=$X'`dependencies_repositories` TEXT NOT NULL,'
  X=$X'`dependencies_packages` TEXT NOT NULL,'
  X=$X'`dependencies_commands` TEXT NOT NULL,'
  X=$X'`template` VARCHAR(50) NOT NULL DEFAULT "default",'
  X=$X'`database` VARCHAR(100) NOT NULL,'
  X=$X'`logo` BLOB NOT NULL,'
  X=$X'`favicon` BLOB NOT NULL,'
  X=$X'`active` enum("T","F") COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "T"'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`sites` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `subdomain` (`subdomain`), ADD KEY `active` (`active`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`sites` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"

  #setup default site entry
  RWTMP='/tmp/rwtmp.txt'
  touch $RWTMP
  echo 'RewriteRule ^/log$ /loginPage.php?%{QUERY_STRING} [PT,L]' >> $RWTMP
  echo 'RewriteRule ^/js/script([0-9-]+).js$ /jsPage.php?q=$1&%{QUERY_STRING} [PT,L]' >> $RWTMP
  echo 'RewriteRule ^/css/style([0-9-]+).css$ /cssPage.php?q=$1&%{QUERY_STRING} [PT,L]' >> $RWTMP
  echo 'RewriteRule ^/favicon.ico$ /a64File.php?f=favicon&t=sites&id=1&%{QUERY_STRING} [PT,L]' >> $RWTMP
  echo 'RewriteRule ^/afile/([a-z0-9_-]+)/([0-9]+).([a-z0-9_-]+).([a-z0-9]+)$ /a64File.php?f=$3&t=$1&id=$2&ext=$4&%{QUERY_STRING} [PT,L]' >> $RWTMP
  R=`cat "$RWTMP"`
  rm $RWTMP

  CRTMP='/tmp/crtmp.txt'
  touch $CRTMP
#  echo '2 2 * * * ~/setup/scripts/cron/backupSystem.sh > ~/cron.backupSystem.log 2>&1' >> $CRTMP
  echo '3 3 3 * * ~/setup/scripts/cron/renewSSLCerts.sh > ~/cron.renewSSLCerts.log 2>&1' >> $CRTMP
#  echo '4 4 * * 6 ~/setup/scripts/cron/updateSystem.sh > ~/cron.updateSystem.log 2>&1' >> $CRTMP
  C=`cat "$CRTMP"`
  rm $CRTMP

  X='INSERT INTO `'"${SYSTEM_DATABASE}"'`.`sites` (`subdomain`,`cronjobs`,`rewrites`) VALUES ("'"${COMPANY_ADMIN_SUBDOMAIN}.${COMPANY_DOMAIN}"'","'"$C"'","'"$R"'");'
  $MY "$X"
fi


#create the site sections table
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'site_sections';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`site_sections` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`site_id` int(10) unsigned NOT NULL,'
  X=$X'`name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`identifier` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`css_ids` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`js_ids` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`active` enum("T","F") COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "T"'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`site_sections` ADD PRIMARY KEY (`id`), ADD KEY `site_id` (`site_id`), ADD KEY `identifier` (`identifier`), ADD KEY `active` (`active`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`site_sections` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"
fi


#create the site pages table
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'site_pages';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`site_pages` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`site_section_id` int(10) unsigned NOT NULL,'
  X=$X'`name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`identifier` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`description` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`keywords` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`code` longtext COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`active` enum("T","F") COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "T"'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`site_pages` ADD PRIMARY KEY (`id`), ADD KEY `site_section_id` (`site_section_id`), ADD KEY `identifier` (`identifier`), ADD KEY `active` (`active`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`site_pages` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"
fi


#create the navigation table
if [[ `$MY "USE ${SYSTEM_DATABASE};SHOW TABLES LIKE 'navigation';" | tail -n +2 | wc -l` -lt 1 ]];then
  X='CREATE TABLE IF NOT EXISTS `'"${SYSTEM_DATABASE}"'`.`navigation` ('
  X=$X'`id` int(10) unsigned NOT NULL,'
  X=$X'`site_id` int(10) unsigned NOT NULL,'
  X=$X'`name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`identifier` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`description` text COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`href` text COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`content` text COLLATE utf8mb4_unicode_ci NOT NULL,'
  X=$X'`active` enum("T","F") COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "T"'
  X=$X') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`navigation` ADD PRIMARY KEY (`id`), ADD KEY `site_id` (`site_id`), ADD KEY `identifier` (`identifier`), ADD KEY `active` (`active`);'
  $MY "$X"

  X='ALTER TABLE `'"${SYSTEM_DATABASE}"'`.`navigation` MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;'
  $MY "$X"
fi


echo " * Done setting up database for default Web site"

exit 0
