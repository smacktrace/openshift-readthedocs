"""OCP Settings mounted at /opt/rtd/readthedocs.org-master/readthedocs/settings/ocp.py"""
from __future__ import absolute_import
import os

from .base import CommunityBaseSettings


class CommunityDevSettings(CommunityBaseSettings):

    """Settings for local development"""

    PRODUCTION_DOMAIN = os.environ['RTD_PRODUCTION_DOMAIN']
    WEBSOCKET_HOST = 'localhost:8088'

    @property
    def DATABASES(self):  # noqa
        return {
            DATABASES = {
                'default': {
                    'ENGINE': 'django.db.backends.postgresql_psycopg2',
                    'NAME': os.environ['RTD_DB_NAME'],
                    'USER': os.environ['RTD_DB_USER'],
                    'PASSWORD': os.environ['RTD_DB_PASSWORD'],
                    'HOST': os.environ['RTD_DB_HOST'],
                    'PORT': '',
                }
            }

        }

    DONT_HIT_DB = False
    SECRET_KEY = os.environ['RTD_DJANGO_SECRET_KEY']

    ACCOUNT_EMAIL_VERIFICATION = 'none'
    SESSION_COOKIE_DOMAIN = None
    CACHE_BACKEND = 'dummy://'

    SLUMBER_USERNAME = 'test'
    SLUMBER_PASSWORD = 'test'  # noqa: ignore dodgy check
    SLUMBER_API_HOST = 'http://0.0.0.0:8000'
    PUBLIC_API_URL = 'http://0.0.0.0:8000'

    BROKER_URL = 'redis://localhost:6379/0'
    CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
    CELERY_RESULT_SERIALIZER = 'json'
    CELERY_ALWAYS_EAGER = True
    CELERY_TASK_IGNORE_RESULT = False

    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
    FILE_SYNCER = 'readthedocs.builds.syncers.LocalSyncer'

    # For testing locally. Put this in your /etc/hosts:
    # 127.0.0.1 test
    # and navigate to http://test:8000
    CORS_ORIGIN_WHITELIST = (
        'test:8000',
    )

    # Disable auto syncing elasticsearch documents in development
    ELASTICSEARCH_DSL_AUTOSYNC = False

    @property
    def LOGGING(self):  # noqa - avoid pep8 N802
        logging = super().LOGGING
        logging['formatters']['default']['format'] = '[%(asctime)s] ' + self.LOG_FORMAT
        # Allow Sphinx and other tools to create loggers
        logging['disable_existing_loggers'] = False
        return logging


CommunityDevSettings.load_settings(__name__)

if not os.environ.get('DJANGO_SETTINGS_SKIP_LOCAL', False):
    try:
        # pylint: disable=unused-wildcard-import
        from .local_settings import *  # noqa
    except ImportError:
        pass

