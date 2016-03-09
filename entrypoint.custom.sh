#!/bin/bash
set -e

# post-install.sh vars
REDMINE_USER=redmine
REDMINE_GROUP=redmine
REDMINE_PLUGIN_DIR=/home/redmine/redmine/plugins

# provide name of database file
REDMINE_SYS_DATA_SQL=redmine-init-system.sql

# Send the db to postgres
PGPASSWORD=$DB_PASS psql --host $DB_HOST --username $DB_USER -d $DB_NAME -f ${REDMINE_DATA_DIR}/${REDMINE_SYS_DATA_SQL}

echo ${CI_ADMIN_PWD}
# Set the admin password
$REDMINE_INSTALL_DIR/bin/rails runner "u=User.find_by_id(1);u.password=\"${REDMINE_ADMIN_PASSWORD}\";u.save!;"

# Copy post-install script to redmine plugins directory - executes on image start
${BASEDIR}/post-install.sh ${REDMINE_NAME}:${REDMINE_PLUGIN_DIR}
${REDMINE_NAME} chown ${REDMINE_USER}:${REDMINE_GROUP} ${REDMINE_PLUGIN_DIR}/post-install.sh
${REDMINE_NAME} chmod 744 ${REDMINE_PLUGIN_DIR}/post-install.sh
