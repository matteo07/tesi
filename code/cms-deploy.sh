#!/bin/bash

set -e

RED_COLOR=`tput setaf 1`
GREEN_COLOR=`tput setaf 2`
RESET_COLOR=`tput sgr0`

CHECKOUT_DIR=wpkiruby
TARFILE=wpkiruby.tar.gz
TARGET_DIR=/media/www/wordpress
WP_CONTENT=wp-content
WP_CONTENT_BKP=wp-content-bkp
UPLOADS=wp-content/uploads

LOGFILE=/media/www/wordpress/wp-content/themes/basic/test/.log.txt
LOAD=/media/www/wordpress/wp-load.php
TESTS=/media/www/wordpress/wp-content/themes/basic/test/.



#CHIEDI USERNAME E CONTINUA DOPO AVER APERTO IL TUNNEL
if [ ! "$1" ]
then
    echo "${RED_COLOR}Si vabbeh! Dimmi dove vuoi deployare! LAB o PRO?${RESET_COLOR}"
    exit
fi
echo -n "Username: "
read username
gnome-terminal -e "$1.sh $username" 2>&1 > /dev/null &
echo "${GREEN_COLOR}========> Tunnellizzati e premi un tasto per continuare${RESET_COLOR}"
read

#SCARICA LA REPO DA GIT, COMPRIME E MANDA DOVE APERTO IL TUNNEL
cd /tmp && git clone git@gitlab.p7intranet.it:teamiguana/wpkiruby.git

tar -czvf $TARFILE $CHECKOUT_DIR
scp -P 20059 /tmp/${TARFILE} root@localhost:${TARGET_DIR}

rm $TARFILE
rm -rf $CHECKOUT_DIR

echo "${GREEN_COLOR}=== ${TARFILE} copied in remote at ${TARGET_DIR} ===${RESET_COLOR}"

echo "=== switch WP-CONTENT and create WP_CONTENT_BKP ==="
#ESEGUITO SU HOST REMOTO
ssh -C -l root -p 20059 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -R 8765:192.168.254.140:22 localhost -i /home/xpuser/shoppydoo/kiruby/key.ssh -t << HERE
    cd /media/www/wordpress; bash --login
    tar -xzf ${TARFILE}
    [ -d $WP_CONTENT_BKP ] && rm -rf $WP_CONTENT_BKP
    rm ${TARFILE}
    mv $WP_CONTENT $WP_CONTENT_BKP && mv $CHECKOUT_DIR $WP_CONTENT
    chmod 777 -R $UPLOADS

	phpunit --bootstrap $LOAD $TESTS > $LOGFILE
	if grep -q 'OK (' $LOGFILE;
	then
		echo '${GREEN_COLOR}All tests passed!! %)${RESET_COLOR}';
	else
		echo '${RED_COLOR}Tests not passed!! :(';
		cat $LOGFILE; echo '${RESET_COLOR}';
		rm -rf $WP_CONTENT && mv $WP_CONTENT_BKP $WP_CONTENT;
	fi
HERE
    echo "${GREEN_COLOR}=== Yoh BRO!! Now CMS is online! CARRAMBA! ===${RESET_COLOR}"


# ----- PER ROLLBACK ACCEDERE ALLA MACCHINA CON kir-blogs.sh ED ESEGUIRE QUESTO COMANDO ----
#WP_CONTENT=wp-content && WP_CONTENT_BKP=wp-content-bkp && cd .. && rm -rf $WP_CONTENT && mv $WP_CONTENT_BKP $WP_CONTENT
