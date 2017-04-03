#/bin/bash 

echo "$(date) Starting curator with {{CURATOR_RETENTION}} retention"

set -x
find /opt/graphite/storage/whisper/ -type f -name "*wsp" -mtime +{{CURATOR_RETENTION}} -delete 
find /opt/graphite/storage/whisper/ -type d -empty -delete
set +x

echo "$(date) Done"
