# kubernetes-graphite-cluster

A ready to deploy graphite cluster to work on top of Kubernetes.

## Contents:
1. A **statsd proxy** deployment and service for metric collection
2. A **statsd daemon** stateful set for metric aggregation and shipping
2. **Carbon relay** deployment and service to spread metrics across several Graphite data nodes
3. **Graphite data nodes** as a stateful set with persistent volumes
4. **Graphite query node** to be used as a query gateway to the data nodes

## Requirements:
1. Kubernetes version 1.5.X (We're using StatefulSet)
2. kubectl configured to work with your Kubernetes API
3. Tested on Kubernetes 1.5.2 on top of AWS (See future work)
4. Optional - Access to your own docker repository to store your own images. That's relevant if you don't want to use the default images offered here.

## Deployment:
1. Clone this repository
2. Run `make deploy`

## Usage:
After the deployment is done there are two endpoints of interest:

1. **statsd:8125** is the host for your metrics collection. It points the statsd proxies.
2. **graphite:80** is the host for you metrics queries. It points to the graphite query node which queries all data nodes in the cluster.

## Building your own images
If you want to build use your own images run `export DOCKER_REPOSITORY=my_company && make deploy`
It will build the images, push them to your docker repository and use them to create all the needed kubernetes deployments.

## Future work
1. Fetch stateful sets (statsd daemons and graphite data nodes) addresses dynamically on startup to allow easier setup for number of replicas in these stateful sets.
2. Store Graphite events on a persistent storage
3. Test on other cloud providers
