#!/bin/bash
set -e

# This script should be placed in the redmine container
# under /home/redmine/redmine/plugins/ and it executes every time the image starts

# Remove repo fetch cronjob for redmine
USER=redmine
STRING='Repository.fetch_changesets'
crontab -r -u $USER
