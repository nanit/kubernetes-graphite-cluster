#!/bin/bash

set -x

/set-cluster-nodes.sh
exec /usr/bin/supervisord
