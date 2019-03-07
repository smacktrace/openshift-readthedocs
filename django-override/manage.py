#!/usr/bin/env python
import os
import sys

"""Updating the manage.py file to account for our openshift settings module"""
""" Mounted via config map to /opt/rtd/readthedocs.org-master/manage.py """

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "readthedocs.settings.ocp")
    sys.path.append(os.getcwd())

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
