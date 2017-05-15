#!/bin/bash

set -x

/set-cluster-nodes.sh
exec /opt/graphite/bin/carbon-relay.py --debug --logdir=/var/log/carbon start

