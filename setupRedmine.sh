#!/bin/bash
set -e

REDMINE_SYS_DATA_SQL=redmine-init-system.sql

docker exec pg-redmine gosu postgres psql -d redmine -U redmine -f /${REDMINE_SYS_DATA_SQL}

# copy autoreg plugin
docker exec redmine git clone https://github.com/steve-dev/redmine_api_auth_fix.git 

docker exec redmine mv redmine_api_auth_fix /home/redmine/redmine/plugins/

# restart redmine - this will break nginx (aka proxy) - must restart nginx (aka proxy)
docker restart redmine

# Required when redmine is restarted to support the plugin install process.
docker restart proxy

