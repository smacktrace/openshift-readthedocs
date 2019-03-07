# -*- coding: utf-8 -*-
from __future__ import absolute_import
import os

"""WSGI application helper."""
"""Used to update Settings module to OCP settings"""
""" mounted to /opt/rtd/readthedocs.org-master/readthedocs/wsgi.py"""

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'readthedocs.settings.ocp')

# This application object is used by any WSGI server configured to use this
# file. This includes Django's development server, if the WSGI_APPLICATION
# setting points here.
from django.core.wsgi import get_wsgi_application  # noqa
application = get_wsgi_application()

# Apply WSGI middleware here.
# from helloworld.wsgi import HelloWorldApplication
# application = HelloWorldApplication(application)

