######################################################
# NAME: Openshift Read the Docs                      #
# Purpose: Documentation via RTD                     #
# https://docs.readthedocs.io/en/stable/install.html #
######################################################

#Using red hat python as base
FROM docker.io/smacktrace/ocp-rtd-base:1.0.0

USER 0 

# Maintained by
MAINTAINER smacktrace <smacktrace942@gmail.com>

# THIS ASSUMES THAT YOU HAVE PROXY ENV VARS SETUP IN BUILD CONFIG

# OCP will override the below env var if set in OCP build config
ENV RTD_ZIP_SOURCE="https://github.com/rtfd/readthedocs.org/archive/master.zip"


#TODO: ADD YOUR CA PEM


#We will use an entrypoint to configure Postgres if ENV exists
ADD docker-entrypoint.sh /sbin

# This daemon makes sure uwsgi is running properly 
ADD config/uwsgi-daemon /sbin


RUN chmod +x /sbin/docker-entrypoint.sh \
	&& chmod +x /sbin/uwsgi-daemon \
        && mkdir -p /var/log/rtd/ \
	#&& chmod 0644  /etc/pki/ca-trust/source/anchors/your-ca.pem \
        #&& update-ca-trust

RUN mkdir /opt/rtd \
	&& curl -L -o /opt/rtd/rtdsource.zip $RTD_ZIP_SOURCE

RUN unzip /opt/rtd/rtdsource.zip -d /opt/rtd/ \
	&& rm -f /opt/rtd/rtdsource.zip

ADD config/requirements.txt /opt/rtd/requirements.txt
ADD config/uwsgi.ini /opt/rtd/uwsgi.ini

#THIS IS ONLY TEMPORARY UNTIL SLUGIFY IS ADDED TO PYPY https://github.com/rtfd/readthedocs.org/blob/f1c15d4f22af0ba7ebf762df1d49f7c28e8d01e5/requirements/pip.txt Line 71
#RUN curl -o /tmp/slug.zip https://github.com/mozilla/unicode-slugify/archive/master.zip \
#	&& unzip /tmp/slug.zip \
#	&& cd unicode-slugify-master/ \
#	&& python3 setup.py install \
#	&& cd -

#Install requiremts for RTD
RUN pip3 install -r /opt/rtd/readthedocs.org-master/requirements.txt

#Install requirements for other dependicies 
RUN pip3 install -r /opt/rtd/requirements.txt

RUN chmod -R 777 /var/log/rtd && \
	chgrp -R 0 /opt  && \
	chmod -R g=u /opt && \
	chmod g=u /etc/passwd

WORKDIR /opt/rtd
EXPOSE 8000
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["uwsgi-daemon"]
USER 1001

