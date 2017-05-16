#!/bin/sh

set -x

/set-cluster-nodes.sh
exec node /app/statsd/proxy.js /app/statsd/proxyConfig.js

