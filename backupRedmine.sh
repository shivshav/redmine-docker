#!/bin/bash

BASEDIR=$(readlink -f $(dirname $0))

set -e
# pull in config variables for container names
source ${BASEDIR}/config
source ${BASEDIR}/config.default
# pull in common variables for postgres/redmine
source ./config

BACKUP_FN=`echo "$(date +%Y-%m-%d\ %H:%M:%S.%N|cut -c 1-22 | tr ' ' '_').sql"`

echo "Beginning data dump . . . "
docker exec ${PG_REDMINE_NAME} pg_dumpall -c -U ${PG_USER} -w -f ${BACKUP_FN}_

echo "Copying backup . . . "
mkdir backups
docker cp ${PG_REDMINE_NAME}:/${BACKUP_FN} ./backups/
