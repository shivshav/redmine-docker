#!/bin/bash
set -e
set -x

BASEDIR=$(readlink -f $(dirname $0))
PG_REDMINE_NAME=${1:-pg-redmine}
POSTGRES_IMAGE=${2:-postgres}
REDMINE_NAME=${3:-redmine}
REDMINE_IMAGE_NAME=${4:-sameersbn/redmine}
REDMINE_VOLUME=${5:-redmine-volume}
GERRIT_VOLUME=${6:-gerrit-volume}
LDAP_SERVER=${7:-openldap}
LDAP_ACCOUNTBASE=${8:-ou=accounts,dc=demo,dc=com} #TODO: Use the env vars to set this
REDMINE_ADMIN_PASSWORD=${9:-my_password}

source ${BASEDIR}/config

# Redmine init data
sed -e "s/{INIT_DATE}/${INIT_DATE}/g" ${BASEDIR}/${REDMINE_SYS_DATA_SQL}.template > ${BASEDIR}/${REDMINE_SYS_DATA_SQL}
sed -i "s/{HOST_IP}/${LDAP_SERVER}/g" ${BASEDIR}/${REDMINE_SYS_DATA_SQL}
sed -i "s/{LDAP_ACCOUNTBASE}/${LDAP_ACCOUNTBASE}/g" ${BASEDIR}/${REDMINE_SYS_DATA_SQL}
sed -e "s/{INIT_DATE}/${INIT_DATE}/g" ${BASEDIR}/${REDMINE_DEMO_DATA_SQL}.template > ${BASEDIR}/${REDMINE_DEMO_DATA_SQL}

# Start PostgreSQL.
docker run \
--name ${PG_REDMINE_NAME} \
-P \
-e POSTGRES_USER=${PG_USER} \
-e POSTGRES_PASSWORD=${PG_PASSWD} \
-e POSTGRES_DB=${PG_DB} \
-v ${BASEDIR}/${REDMINE_SYS_DATA_SQL}:/${REDMINE_SYS_DATA_SQL}:ro \
-v ${BASEDIR}/${REDMINE_DEMO_DATA_SQL}:/${REDMINE_DEMO_DATA_SQL}:ro \
-d ${POSTGRES_IMAGE}

while [ -z "$(docker logs ${PG_REDMINE_NAME} 2>&1 | grep 'autovacuum launcher started')" ]; do
    echo "Waiting postgres ready."
    sleep 1
done

# Create Redmine volume.
docker run \
--name ${REDMINE_VOLUME} \
--entrypoint="echo" \
${REDMINE_IMAGE_NAME} \
"Create Redmine volume."

# Start Redmine.
docker run \
--name=${REDMINE_NAME} \
--link ${PG_REDMINE_NAME}:postgresql \
--link ${LDAP_SERVER}:openldap \
-e DB_NAME=redmine \
-e LDAP_SERVER=${LDAP_SERVER} \
-e REDMINE_RELATIVE_URL_ROOT=/redmine \
-e REDMINE_FETCH_COMMITS=hourly \
-e NGINX_MAX_UPLOAD_SIZE=${NGINX_MAX_UPLOAD_SIZE} \
-e REDMINE_ADMIN_PASSWORD=$REDMINE_ADMIN_PASSWORD \
-e REDMINE_FETCH_COMMITS=disable \
--volumes-from ${REDMINE_VOLUME} \
--volumes-from ${GERRIT_VOLUME}:ro \
-d ${REDMINE_IMAGE_NAME}
