# graphite-kubernetes-cluster

A ready to deploy graphite cluster to work on top of Kubernetes.

## Contents:
1. A statsd proxy deployment and service for metric collection
2. A statsd daemon stateful set for metric aggregation and shipping
2. Carbon relay deployment and service to spread metrics across several Graphite data nodes
3. Graphite data nodes as a stateful set with persistent volumes
4. Graphite query node to be used as a query gateway to the data nodes

## Requirements:
1. Kubernetes version 1.5.X (We're using StatefulSet)
2. kubectl configured to work with your Kubernetes API

## Deployment:
1. Clone this repository
2. Run `make deploy`


