#!/bin/bash
BASEDIR=$(readlink -f $(dirname $0))
BACKUP_DIR=backups

set -e
# pull in config variables for container names
source ${BASEDIR}/../../config
source ${BASEDIR}/../../config.default
# pull in common variables for postgres/redmine
source ${BASEDIR}/config

BACKUP_FN=`echo "$(date +%Y-%m-%d\ %H:%M:%S.%N|cut -c 1-22 | tr ' ' '_').sql"`

echo "Beginning data dump... "
docker exec ${PG_REDMINE_NAME} pg_dumpall -c -U ${PG_USER} -w -f ${BACKUP_FN} || { 
    echo "Backup failed!"
    exit 1
}

echo "Copying backup... "
mkdir -p ${BACKUP_DIR} 
docker cp ${PG_REDMINE_NAME}:/${BACKUP_FN} ${BACKUP_DIR}/ || {
    echo "Copy failed!"
    exit 1
}

echo "Backup Completed!"
