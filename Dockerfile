FROM sameersbn/redmine
MAINTAINER steve-dev@gmail.com

ENV REDMINE_ADMIN_PASSWORD="my_password"

RUN git clone --verbose https://github.com/steve-dev/redmine_api_auth_fix.git /home/redmine/redmine/plugins/redmine_api_auth_fix

COPY entrypoint.custom.sh ${REDMINE_DATA_DIR}/
COPY redmine-init-system.sql.template ${REDMINE_DATA_DIR}/

RUN chmod 755 ${REDMINE_DATA_DIR}/entrypoint.custom.sh
