#!/bin/bash

set -x

if [ -n "$CURATOR_RETENTION" ]
then
  sed -i "s/{{CURATOR_RETENTION}}/$CURATOR_RETENTION/g" /etc/cron.d/curator.sh
  crontab -u root /etc/cron.d/curator.cron
fi

exec /usr/bin/supervisord
