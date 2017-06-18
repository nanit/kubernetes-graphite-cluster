#!/bin/bash

set -x
set -e

/set-cluster-nodes.sh
exec node /app/statsd/proxy.js /app/statsd/proxyConfig.js

