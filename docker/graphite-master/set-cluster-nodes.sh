#/bin/bash

set -e
set -u

function join_by { local IFS="$1"; shift; echo "$*"; }

STATEFUL_SETS=$(curl -f -k https://kubernetes/apis/apps/v1beta1/statefulsets -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)")
GRAPHITE_NODES_SS=$(echo $STATEFUL_SETS | jq '.items[] | select(.metadata.name == "graphite-node")')
REPLICAS=$(echo $GRAPHITE_NODES_SS | jq .spec.replicas)
SERVICE_NAME=$(echo $GRAPHITE_NODES_SS | jq .spec.serviceName | tr -d '"')
(( REPLICAS-= 1 ))
NODES=()

for i in $(seq 0 $REPLICAS)
do
  NODES+=("\"graphite-node-$i.$SERVICE_NAME:80\"")
done

JOINED=$(join_by , "${NODES[@]}")

sed -i "s/@@GRAPHITE_NODES@@/$JOINED/g" /opt/graphite/webapp/graphite/local_settings.py
