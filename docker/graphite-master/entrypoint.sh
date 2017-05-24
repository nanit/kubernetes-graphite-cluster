#!/bin/bash

set -x

/set-cluster-nodes.sh
cd /opt/graphite/webapp/ && python manage.py migrate --run-syncdb --noinput
exec /usr/bin/supervisord
