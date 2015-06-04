#!/bin/bash
set -e

PG_REDMINE_NAME=${PG_REDMINE_NAME:-pg-redmine}
REDMINE_NAME=${REDMINE_NAME:-redmine}
REDMINE_IMAGE_NAME=${REDMINE_IMAGE_NAME:-sameersbn/redmine}
REDMINE_VOLUME=${REDMINE_VOLUME:-redmine-volume}
GERRIT_VOLUME=${GERRIT_VOLUME:-gerrit-volume}

REDMINE_SYS_DATA_SQL=redmine-init-system.sql
REDMINE_DEMO_DATA_SQL=redmine-init-demo.sql
INIT_DATE=`date +%Y-%m-%d\ %H:%M:%S.%N|cut -c 1-26`

# Stop and remove redmine container.
docker stop ${REDMINE_NAME}
docker rm -v ${REDMINE_NAME}

# Redmine init data
sed -e "s/{INIT_DATE}/${INIT_DATE}/g" ~/redmine-docker/${REDMINE_SYS_DATA_SQL}.template > ~/redmine-docker/${REDMINE_SYS_DATA_SQL}
sed -i "s/{HOST_IP}/${LDAP_SERVER}/g" ~/redmine-docker/${REDMINE_SYS_DATA_SQL}
sed -i "s/{LDAP_ACCOUNTBASE}/${LDAP_ACCOUNTBASE}/g" ~/redmine-docker/${REDMINE_SYS_DATA_SQL}
sed -e "s/{INIT_DATE}/${INIT_DATE}/g" ~/redmine-docker/${REDMINE_DEMO_DATA_SQL}.template > ~/redmine-docker/${REDMINE_DEMO_DATA_SQL}

# Start Redmine.
docker run \
--name=${REDMINE_NAME} \
--link pg-redmine:postgresql \
-e DB_NAME=redmine \
-e REDMINE_RELATIVE_URL_ROOT=/redmine \
-e REDMINE_FETCH_COMMITS=hourly \
--volumes-from ${REDMINE_VOLUME} \
--volumes-from ${GERRIT_VOLUME}:ro \
-d ${REDMINE_IMAGE_NAME}