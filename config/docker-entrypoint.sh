#!/bin/bash
##  Docker Entrypoint for NETBOX on Openshift
##  MAINTAINER smacktrace <smacktrace942@gmail.com>

set -e

##################### CONFIGURE ARBITRARY OCP USER ################################
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

###################### PYTHON SETUP ###############################################

export alias python=python3.6

##########################   DJANGO SETUP  #######################################

if [[ -z "${DJANGO_SETTINGS_MODULE}" ]]; then
  echo "*** WARNING YOU ARE USING DEV SETTINGS ***"
  echo "[NOTICE-ENTRYPOINT]----> Django Collect Static Files"
  python /opt/rtd/readthedocs.org-master/manage.py collectstatic
  wait
  
  echo "[NOTICE-ENTRYPOINT]----> Django Migrate DB"
  python /opt/rtd/readthedocs.org-master/manage.py migrate
  wait

  echo "[NOTICE-ENTRYPOINT]----> Django Create SuperUser"
  echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@rtfd.com', 'admin123')" | python manage.py shell
  echo "[NOTICE-ENTRYPOINT]----> Please use the below demo credentials to log into the dashboard and admin site"
  echo "[NOTICE-ENTRYPOINT]----> DEV USER:     admin"
  echo "[NOTICE-ENTRYPOINT]----> DEV PASSWORD: admin123"
  wait

  echo "[NOTICE-ENTRYPOINT]----> Django Loading Test Data"
  python /opt/rtd/readthedocs.org-master/manage.py loaddata test_data
  wait

  echo "[NOTICE-ENTRYPOINT]----> Django startup complete"

else
  echo "[NOTICE-ENTRYPOINT]----> USING DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE} to start server"
fi

##########################      RUN CMD    ########################################

exec "$@"

