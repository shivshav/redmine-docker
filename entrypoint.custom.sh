#!/bin/bash
set -e

# provide name of database file
REDMINE_SYS_DATA_SQL=redmine-init-system.sql

# Send the db to postgres
PGPASSWORD=$DB_PASS psql --host $DB_HOST --username $DB_USER -d $DB_NAME -f ${REDMINE_DATA_DIR}/${REDMINE_SYS_DATA_SQL}
