#!/bin/bash
#date
DATA=`date +"%Y-%m-%d_%H-%M"`

#backup dir
backupdir="/home/momai/project/backupbd"

. /home/momai/project/.env

docker exec mysql /usr/bin/mysqldump --defaults-extra-file=/var/lib/mysql-credentials.cnf test > "$backupdir"/"$DATA"-test.sql
/usr/bin/find "$backupdir" -type f -mtime +10 -exec rm -rf {} \;
