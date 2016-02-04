#/bin/bash

PG_REDMINE_NAME=${PG_REDMINE_NAME:-pg-redmine}
REDMINE_NAME=${REDMINE_NAME:-redmine}
REDMINE_VOLUME=${REDMINE_VOLUME:-redmine-volume}

echo "Removing ${REDMINE_NAME}..."
docker stop ${REDMINE_NAME} &> /dev/null
docker rm -v ${REDMINE_NAME} &> /dev/null

echo "Removing ${REDMINE_VOLUME}..."
docker rm -v ${REDMINE_VOLUME} &> /dev/null

echo "Removing ${PG_REDMINE_NAME}..."
docker stop ${PG_REDMINE_NAME} &> /dev/null
docker rm -v ${PG_REDMINE_NAME} &> /dev/null
