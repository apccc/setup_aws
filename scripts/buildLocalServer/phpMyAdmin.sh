#!/bin/bash

source ~/setup_aws.conf.sh

echo " * Setting up phpMyAdmin"

#start by setting up apache2
~/setup_aws/scripts/buildLocalServer/apache2Web.sh

#install phpMyAdmin
sudo ~/setup_aws/scripts/buildLocalServer/phpMyAdmin/install.sh

FORIG=/etc/phpmyadmin/apache.conf
F=/tmp/setup.phpmyadmin.conf
cp $FORIG $F
echo " * Configuring \"$FORIG\":"
$FR 'Alias /phpmyadmin /usr/share/phpmyadmin' "Alias /${PHPMYADMIN_FOLDER} /usr/share/phpmyadmin" $F
FIND=$(echo -e '<Directory /usr/share/phpmyadmin>\n    Options FollowSymLinks')
REPLACE=$(echo -e '<Directory /usr/share/phpmyadmin>\n\tOrder deny,allow\n\tDeny from all\n\tOptions FollowSymLinks')
$FR "$FIND" "$REPLACE" $F

L=`grep -n 'Options FollowSymLinks' $F | cut -d':' -f1`
for X in `echo "$WHITELISTEDIPS" | tr ' ' '\n'`;do
        A=`echo -e "\tAllow from $X"`
        $AP "$A" $F $L
done
cat $F | sudo tee $FORIG > /dev/null
rm $F

echo ''


#Configure the servers to manage
FORIG=/etc/phpmyadmin/config.inc.php
cp $FORIG $F
echo " * Configuring \"$FORIG\":"
#remove any existing servers
while [ 1 ];do
        X=`grep -m 1 -n '^$i++;$cfg' $F | cut -d':' -f1`
        if [ -z "$X" ];then
                break
        fi
        sed -i $X'd' $F
done

L=`grep -n 'You can disable a server config entry by setting host to' $F | cut -d':' -f1`
L=$((L-1))

$AP '$i++;$cfg["Servers"][$i]["host"]="127.0.0.1";' $F $L

cat $F | sudo tee $FORIG > /dev/null
rm $F

#Add in the servers
#L=`grep -n 'You can disable a server config entry by setting host to' $F | cut -d':' -f1`
#L=$((L-1))
#for XIP in $($MY 'SELECT ip FROM cSystem.servers WHERE `isMySQL`="T" ORDER BY `ip` DESC' | tail -n +2);do
#        $AP '$i++;$cfg["Servers"][$i]["host"]="'"$XIP"'";' $F $L
#done
echo ''



sudo /etc/init.d/apache2 restart
echo ''


echo " * Note: MySQL Servers May Need To Authorize This PHPMyAdmin Server to Access Databases."


echo " * Done setting up phpMyAdmin"

exit 0
