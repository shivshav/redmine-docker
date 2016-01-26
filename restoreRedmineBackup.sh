#!/bin/bash

# Function to get the most recently modified file in a directory
#
# Parameters
#   $1: directory to search
#
function get_newest_file(){
    cd $1
    files=(*) newest=${files[0]}
    for f in "${files[@]}"; do
        if [[ $f -nt $newest ]]; then
            newest=$f
        fi
    done
    cd ..
}

set -e

BASEDIR=$(readlink -f $(dirname $0))
BACKUP_DIR=backups
get_newest_file ${BACKUP_DIR}
BACKUP_FN=${newest}

# pull in config variables for container names
source ${BASEDIR}/../../config
source ${BASEDIR}/../../config.default
# pull in common variables for postgres/redmine
source ${BASEDIR}/config


echo "Coping backup to ${PG_REDMINE_NAME} container "
docker cp ${BACKUP_DIR}/${BACKUP_FN} ${PG_REDMINE_NAME}:/ || {
    echo "Copy failed!"
    exit 1
}

echo "Start restore of backup "
docker exec ${PG_REDMINE_NAME} psql -U ${PG_USER} -f ${BACKUP_FN}  postgres 1>/dev/null || { 
    echo "Backup failed!"
    exit 1
}

echo "Backup Restored!"
