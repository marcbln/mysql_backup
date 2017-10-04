#!/bin/bash

#
# 10/2017
#
# makes mysql backup of one database using mysqldump
# compresses the backup and deletes older backups



# ---- config

MAX_NUMBER_OF_BACKUPS=40
DATABASE=smartdonation # your_db_name_here
PATH_BACKUP_DIR=/tmp # /your/mysql/backup/path/here
PATH_BACKUP_FILE_SQL=${PATH_BACKUP_DIR}/${DATABASE}.bak__`date +%y-%m-%d_%H%M`.sql
PATH_BACKUP_FILE_BZ2=${PATH_BACKUP_FILE_SQL}.bz2


# ---- create sql dump (assumes valid credentials in ~/.my.cnf)

mysqldump ${DATABASE} > ${PATH_BACKUP_FILE_SQL}


# ---- compress file

echo "compressing $PATH_BACKUP_FILE_SQL to $PATH_BACKUP_FILE_BZ2..."
bzip2 ${PATH_BACKUP_FILE_SQL}


# ---- delete older backups

echo "deleting older backups..."

function number_of_backups() {
    echo `ls -1 $PATH_BACKUP_DIR | wc -l`
}

function oldest_backup() {
    echo -n `ls -1tr $PATH_BACKUP_DIR | head -1`
}

while [ $(number_of_backups) -gt $MAX_NUMBER_OF_BACKUPS ]
do
    rm -f "$PATH_BACKUP_DIR/$(oldest_backup)"
done




# # ---- sync to external server
#
# echo "syncing $PATH_BACKUP_DIR to external server via rsync"
# rsync ...
