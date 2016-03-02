#!/bin/bash
set -e
set -x

# provide name of database file
REDMINE_SYS_DATA_SQL=redmine-init-system.sql

# Send the db to postgres
PGPASSWORD=$DB_PASS psql --host $DB_HOST --username $DB_USER -d $DB_NAME -f ${REDMINE_DATA_DIR}/${REDMINE_SYS_DATA_SQL}

echo ${CI_ADMIN_PWD}
# Set the admin password
$REDMINE_INSTALL_DIR/bin/rails runner "u=User.find_by_id(1);u.password=\"${REDMINE_ADMIN_PASSWORD}\";u.save!;"

