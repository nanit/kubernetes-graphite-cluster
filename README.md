# kubernetes-graphite-cluster

A ready to deploy graphite cluster to work on top of Kubernetes.
Find the full details [here](https://medium.com/@erezrabih/creating-a-graphite-cluster-on-kubernetes-6b402a8a7438#.yyaz16gzq)

## Contents:
1. A **statsd proxy** deployment and service for metric collection
2. A **statsd daemon** stateful set for metric aggregation and shipping
2. **Carbon relay** deployment and service to spread metrics across several Graphite data nodes
3. **Graphite data nodes** as a stateful set with persistent volumes
4. **Graphite query node** to be used as a query gateway to the data nodes

## Requirements:
1. Kubernetes version 1.5.X (We're using StatefulSet)
2. kubectl configured to work with your Kubernetes API
3. Tested on Kubernetes 1.5.2 on top of AWS/[GKE](https://github.com/nanit/kubernetes-graphite-cluster/issues/6)
4. Optional - Access to your own docker repository to store your own images. That's relevant if you don't want to use the default images offered here.

## Environment Variables:
| Name                            | Default Value | Purpose                                                                                                                              | Can be changed? |
|---------------------------------|---------------|--------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| DOCKER_REPOSITORY               | nanit         | Change it if you want to build and use custom docker repository. nanit images are public so leaving it as it is should work out of the box. | Yes             |
| SUDO                            | sudo          | Should docker commands be prefixed with sudo. Change to "" to omit sudo.                                                             | Yes             |
| STATSD_PROXY_REPLICAS           | None          | Number of replicas for statsd proxy                                                                                                  | Yes             |
| STATSD_DAEMON_REPLICAS          | None          | Must be set to 4                                                                                                                     | No              |
| CARBON_RELAY_REPLICAS           | None          | Number of replicas for carbon relay                                                                                                  | Yes             |
| GRAPHITE_NODE_REPLICAS          | None          | Can be set to any number. This number affects both carbon relay and graphite master configuration.                                   | Yes             |
| GRAPHITE_NODE_CURATOR_RETENTION | None          | Set this variable to run a cronjob which deletes metrics that haven't been written for X days                                        | Yes             |
| GRAPHITE_MASTER_REPLICAS        | None          | Number of replicas for graphite query node                                                                                           | Yes             |

## Deployment:
1. Clone this repository
2. Run:
```
export DOCKER_REPOSITORY=nanit && \
export STATSD_PROXY_REPLICAS=3 && \
export STATSD_DAEMON_REPLICAS=4 && \
export CARBON_RELAY_REPLICAS=3 && \
export GRAPHITE_NODE_REPLICAS=7 && \
export GRAPHITE_NODE_CURATOR_RETENTION=5 && \
export GRAPHITE_MASTER_REPLICAS=2 && \
export SUDO="" && \
make deploy
```
## Usage:
After the deployment is done there are two endpoints of interest:

1. **statsd:8125** is the host for your metrics collection. It points the statsd proxies.
2. **graphite:80** is the host for you metrics queries. It points to the graphite query node which queries all data nodes in the cluster.


## Verifying The Deployment:
To verify everything works as expected:

1. Enter an interactive shell session in one of the pods: `kubectl exec -it statsd-daemon-0 /bin/sh`
2. run `echo "test_counter:1|c" | nc -w1 -u statsd 8125` a few times to get some data into Graphite
3. Install curl `apk --update add curl`
4. Fetch data from Graphite: `curl 'graphite/render?target=stats.counters.test_counter.count&from=-10min&format=json'`

You should see a lot of null values along with your few increments at the end.

## Building your own images
If you want to build use your own images make sure to change the DOCKER_REPOSITORY environment variable to your own docker repository.
It will build the images, push them to your docker repository and use them to create all the needed kubernetes deployments.

## Future work

MOVED TO ISSUES

## Acknowledgement

1. I have learnt a lot about Graphite clustering from [this excellent article](https://grey-boundary.io/the-architecture-of-clustering-graphite)
2. The docker images for the graphite nodes are based on [this repository](https://github.com/nickstenning/docker-graphite)
