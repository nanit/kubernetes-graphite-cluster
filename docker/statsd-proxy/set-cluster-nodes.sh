#/bin/bash

set -e
set -u

function join_by { local IFS="$1"; shift; echo "$*"; }

STATEFUL_SETS=$(curl -f -k https://kubernetes/apis/apps/v1beta1/statefulsets -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)")
STATSD_NODES_SS=$(echo $STATEFUL_SETS | jq '.items[] | select(.metadata.name == "statsd-daemon")')
REPLICAS=$(echo $STATSD_NODES_SS | jq .spec.replicas)
SERVICE_NAME=$(echo $STATSD_NODES_SS | jq .spec.serviceName | tr -d '"')
(( REPLICAS-= 1 ))
NODES=()

for i in $(seq 0 $REPLICAS)
do
  NODES+=("{host: 'statsd-daemon-$i.$SERVICE_NAME', port: 8125, adminport:8126}")
done

JOINED=$(join_by , "${NODES[@]}")

sed -i "s/@@STATSD_NODES@@/$JOINED/g" /app/statsd/proxyConfig.js
