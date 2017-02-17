#!/bin/bash

chown -R www-data /opt/graphite/storage/whisper 
chmod -R 0775 /opt/graphite/storage/whisper 
/opt/graphite/bin/carbon-cache.py --debug start
