######################################################
# NAME: Openshift Read the Docs                      #
# Purpose: Documentation via RTD                     #
# https://docs.readthedocs.io/en/stable/install.html #
######################################################

# Using smacktrace base image with dependencies 
# Seperated base reqs from RTD install making updating RTD easier

FROM docker.io/smacktrace/ocp-rtd-base:1.0.0

USER 0 

MAINTAINER smacktrace <smacktrace942@gmail.com>


# OCP will override the below env var if set in OCP build config
ENV RTD_ZIP_SOURCE="https://github.com/rtfd/readthedocs.org/archive/master.zip"


#TODO: ADD YOUR CA PEM


#We will use an entrypoint to configure Postgres if ENV exists
ADD config/docker-entrypoint.sh /sbin

# This daemon makes sure uwsgi is running properly 
ADD config/uwsgi-daemon /sbin


RUN chmod +x /sbin/docker-entrypoint.sh \
	&& chmod +x /sbin/uwsgi-daemon \
        && mkdir -p /var/log/rtd/ 
	#&& chmod 0644  /etc/pki/ca-trust/source/anchors/your-ca.pem \
        #&& update-ca-trust

RUN mkdir /opt/rtd && \
        curl -L -o /opt/rtd/rtdsource.zip $RTD_ZIP_SOURCE && \
        unzip /opt/rtd/rtdsource.zip -d /opt/rtd/ && \
        rm -f /opt/rtd/rtdsource.zip

# A few files we need to replace with OpenShift configurations
ADD django-override/manage.py /opt/rtd/readthedocs.org-master/manage.py
ADD django-override/ocp.py /opt/rtd/readthedocs.org-master/readthedocs/settings/ocp.py 
ADD django-override/wsgi.py /opt/rtd/readthedocs.org-master/readthedocs/wsgi.py

# Add our own requirements file and uwsgi config
ADD config/requirements.txt /opt/rtd/requirements.txt
ADD config/uwsgi.ini /opt/rtd/uwsgi.ini

#THIS IS ONLY TEMPORARY UNTIL SLUGIFY IS ADDED TO PYPY https://github.com/rtfd/readthedocs.org/blob/f1c15d4f22af0ba7ebf762df1d49f7c28e8d01e5/requirements/pip.txt Line 71
#RUN curl -o /tmp/slug.zip https://github.com/mozilla/unicode-slugify/archive/master.zip \
#	&& unzip /tmp/slug.zip \
#	&& cd unicode-slugify-master/ \
#	&& python3 setup.py install \
#	&& cd -

#Install requiremts for RTD and UWSGI
RUN pip install -r /opt/rtd/readthedocs.org-master/requirements.txt -r /opt/rtd/requirements.txt

RUN chmod -R 770 /var/log/rtd && \
	chgrp -R 0 /opt  && \
	chmod -R g=u /opt && \
	chmod g=u /etc/passwd

WORKDIR /opt/rtd/readthedocs.org-master
EXPOSE 8000
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["python","manage.py","runserver","0.0.0.0:8000"]
#TODO: Integrate UWSGI 
#CMD ["uwsgi-daemon"]
USER 1001

