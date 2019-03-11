#######################################################
# Base Image for ReadTheDocs on OpenShift             #
#                                                     #
# https://docs.readthedocs.io/en/stable/install.html  #
#######################################################


FROM centos:7

MAINTAINER smacktrace <smacktrace942@gmail.com>


# Dependencis
# - Python 3.6 
# - virtualenv
# - Git (version >=2.17.0)
# - Mercurial (only if you need to work with mercurial repositories)
# - Pip (version >1.5)
# - Redis

#Yum Installs
#Wandisco repo used to install 2. version of git centos 7
RUN yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm \
        epel-release && \
        yum makecache fast && \
        yum install -y gcc \
        git \
        openssl-devel \ 
        bzip2-devel  \
        libffi-devel \
        make \
        epel-release \
        redis \
        python36 \
        python36-devel \
        uwsgi-plugin-python36 \
        libxml2-devel \
        libxslt-devel \
        unzip \
        && yum clean all -y

#Python setup and configuration
RUN echo "alias python=python3.6" >> /root/.bashrc && \
        source /root/.bashrc && \
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
        python3.6 get-pip.py && \
        ln -sf /usr/bin/python3.6 /usr/bin/python && \
        rm -rf get-pip.py && \
        pip install virtualenv
