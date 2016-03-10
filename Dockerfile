FROM sameersbn/redmine
MAINTAINER steve-dev@gmail.com

ENV REDMINE_ADMIN_PASSWORD="my_password"
ENV REDMINE_PLUGIN_DIR=/home/redmine/redmine/plugins

RUN git clone --verbose https://github.com/steve-dev/redmine_api_auth_fix.git /home/redmine/redmine/plugins/redmine_api_auth_fix

COPY entrypoint.custom.sh ${REDMINE_DATA_DIR}/
COPY redmine-init-system.sql.template ${REDMINE_DATA_DIR}/
COPY post-install.sh ${REDMINE_PLUGIN_DIR}

RUN chown ${REDMINE_USER}:${REDMINE_GROUP} ${REDMINE_PLUGIN_DIR}/post-install.sh
RUN chmod 755 ${REDMINE_PLUGIN_DIR}/post-install.sh
RUN chmod 755 ${REDMINE_DATA_DIR}/entrypoint.custom.sh
