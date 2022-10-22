#!/bin/bash

#env file
. ~/nginx-phpfpm-mysql-phpmyadmin/.env

#date
DATA=`date +"%Y-%m-%d_%H-%M"`

#backup dir
backupdir="$HOMEDIR/backupbd"

docker exec mysql /usr/bin/mysqldump --defaults-extra-file=/var/lib/mysql-credentials.cnf test > "$backupdir"/"$DATA"-test.sql
/usr/bin/find "$backupdir" -type f -mtime +10 -exec rm -rf {} \;
