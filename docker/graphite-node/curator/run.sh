#/bin/bash 

set -x

echo "Starting curator with {{CURATOR_RETENTION}} retention"

find /opt/graphite/storage/whisper/ -type f -name "*wsp" -mtime +{{CURATOR_RETENTION}} -delete 
find /opt/graphite/storage/whisper/ -type d -empty -delete

echo "Done"
