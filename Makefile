STATSD_PROXY_APP_NAME=statsd
STATSD_PROXY_DIR_NAME=statsd-proxy
STATSD_PROXY_DOCKER_DIR=docker/$(STATSD_PROXY_DIR_NAME)
STATSD_PROXY_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(STATSD_PROXY_DOCKER_DIR))
STATSD_PROXY_IMAGE_NAME=nanit/$(STATSD_PROXY_APP_NAME):$(STATSD_PROXY_IMAGE_TAG)
STATSD_PROXY_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(STATSD_PROXY_APP_NAME)/replicas)

define generate-statsd-proxy-svc
	sed -e 's/{{APP_NAME}}/$(STATSD_PROXY_APP_NAME)/g' kube/$(STATSD_PROXY_DIR_NAME)/svc.yml
endef

define generate-statsd-proxy-dep
	if [ -z "$(STATSD_PROXY_REPLICAS)" ]; then echo "ERROR: STATSD_PROXY_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(STATSD_PROXY_APP_NAME)/g;s,{{IMAGE_NAME}},$(STATSD_PROXY_IMAGE_NAME),g;s/{{REPLICAS}}/$(STATSD_PROXY_REPLICAS)/g' kube/$(STATSD_PROXY_DIR_NAME)/dep.yml
endef

deploy-statsd-proxy: docker-statsd-proxy
	kubectl get svc $(STATSD_PROXY_APP_NAME) || $(call generate-statsd-proxy-svc) | kubectl create -f -
	$(call generate-statsd-proxy-dep) | kubectl apply -f -

docker-statsd-proxy:
	sudo docker pull $(STATSD_PROXY_IMAGE_NAME) || (sudo docker build -t $(STATSD_PROXY_IMAGE_NAME) $(STATSD_PROXY_DOCKER_DIR) && sudo docker push $(STATSD_PROXY_IMAGE_NAME))

#-------------------------------------------------------------------------------------------------------------------------------------------------
STATSD_DAEMON_APP_NAME=statsd-daemon
STATSD_DAEMON_DIR_NAME=statsd-daemon
STATSD_DAEMON_DOCKER_DIR=docker/$(STATSD_DAEMON_DIR_NAME)
STATSD_DAEMON_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(STATSD_DAEMON_DOCKER_DIR))
STATSD_DAEMON_IMAGE_NAME=nanit/$(STATSD_DAEMON_APP_NAME):$(STATSD_DAEMON_IMAGE_TAG)
STATSD_DAEMON_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(STATSD_DAEMON_APP_NAME)/replicas)

define generate-statsd-daemon-svc
	sed -e 's/{{APP_NAME}}/$(STATSD_DAEMON_APP_NAME)/g' kube/$(STATSD_DAEMON_DIR_NAME)/svc.yml
endef

define generate-statsd-daemon-dep
	if [ -z "$(STATSD_DAEMON_REPLICAS)" ]; then echo "ERROR: STATSD_DAEMON_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(STATSD_DAEMON_APP_NAME)/g;s,{{IMAGE_NAME}},$(STATSD_DAEMON_IMAGE_NAME),g;s/{{REPLICAS}}/$(STATSD_DAEMON_REPLICAS)/g' kube/$(STATSD_DAEMON_DIR_NAME)/stateful.set.yml
endef

deploy-statsd-daemon: docker-statsd-daemon
	kubectl get svc $(STATSD_DAEMON_APP_NAME) || $(call generate-statsd-daemon-svc) | kubectl create -f -
	$(call generate-statsd-daemon-dep) | kubectl apply -f -

docker-statsd-daemon:
	sudo docker pull $(STATSD_DAEMON_IMAGE_NAME) || (sudo docker build -t $(STATSD_DAEMON_IMAGE_NAME) $(STATSD_DAEMON_DOCKER_DIR) && sudo docker push $(STATSD_DAEMON_IMAGE_NAME))

#-------------------------------------------------------------------------------------------------------------------------------------------------
CARBON_RELAY_APP_NAME=carbon-relay
CARBON_RELAY_DIR_NAME=carbon-relay
CARBON_RELAY_DOCKER_DIR=docker/$(CARBON_RELAY_DIR_NAME)
CARBON_RELAY_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(CARBON_RELAY_DOCKER_DIR))
CARBON_RELAY_IMAGE_NAME=nanit/$(CARBON_RELAY_APP_NAME):$(CARBON_RELAY_IMAGE_TAG)
CARBON_RELAY_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(CARBON_RELAY_APP_NAME)/replicas)

define generate-carbon-relay-svc
	sed -e 's/{{APP_NAME}}/$(CARBON_RELAY_APP_NAME)/g' kube/$(CARBON_RELAY_DIR_NAME)/svc.yml
endef

define generate-carbon-relay-dep
	if [ -z "$(CARBON_RELAY_REPLICAS)" ]; then echo "ERROR: CARBON_RELAY_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(CARBON_RELAY_APP_NAME)/g;s,{{IMAGE_NAME}},$(CARBON_RELAY_IMAGE_NAME),g;s/{{REPLICAS}}/$(CARBON_RELAY_REPLICAS)/g' kube/$(CARBON_RELAY_DIR_NAME)/dep.yml
endef

deploy-carbon-relay: docker-carbon-relay
	kubectl get svc $(CARBON_RELAY_APP_NAME) || $(call generate-carbon-relay-svc) | kubectl create -f -
	$(call generate-carbon-relay-dep) | kubectl apply -f -

docker-carbon-relay:
	sudo docker pull $(CARBON_RELAY_IMAGE_NAME) || (sudo docker build -t $(CARBON_RELAY_IMAGE_NAME) $(CARBON_RELAY_DOCKER_DIR) && sudo docker push $(CARBON_RELAY_IMAGE_NAME))

#-------------------------------------------------------------------------------------------------------------------------------------------------
GRAPHITE_NODE_APP_NAME=graphite-node
GRAPHITE_NODE_DIR_NAME=graphite-node
GRAPHITE_NODE_DOCKER_DIR=docker/$(GRAPHITE_NODE_DIR_NAME)
GRAPHITE_NODE_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(GRAPHITE_NODE_DOCKER_DIR))
GRAPHITE_NODE_IMAGE_NAME=nanit/$(GRAPHITE_NODE_APP_NAME):$(GRAPHITE_NODE_IMAGE_TAG)
GRAPHITE_NODE_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_NODE_APP_NAME)/replicas)

define generate-graphite-node-svc
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_NODE_APP_NAME)/g' kube/$(GRAPHITE_NODE_DIR_NAME)/svc.yml
endef

define generate-graphite-node-dep
	if [ -z "$(GRAPHITE_NODE_REPLICAS)" ]; then echo "ERROR: GRAPHITE_NODE_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_NODE_APP_NAME)/g;s,{{IMAGE_NAME}},$(GRAPHITE_NODE_IMAGE_NAME),g;s/{{REPLICAS}}/$(GRAPHITE_NODE_REPLICAS)/g' kube/$(GRAPHITE_NODE_DIR_NAME)/stateful.set.yml
endef

deploy-graphite-node: docker-graphite-node
	kubectl get svc $(GRAPHITE_NODE_APP_NAME) || $(call generate-graphite-node-svc) | kubectl create -f -
	$(call generate-graphite-node-dep) | kubectl apply -f -

docker-graphite-node:
	sudo docker pull $(GRAPHITE_NODE_IMAGE_NAME) || (sudo docker build -t $(GRAPHITE_NODE_IMAGE_NAME) $(GRAPHITE_NODE_DOCKER_DIR) && sudo docker push $(GRAPHITE_NODE_IMAGE_NAME))

#-------------------------------------------------------------------------------------------------------------------------------------------------
GRAPHITE_MASTER_APP_NAME=graphite
GRAPHITE_MASTER_DIR_NAME=graphite-master
GRAPHITE_MASTER_DOCKER_DIR=docker/$(GRAPHITE_MASTER_DIR_NAME)
GRAPHITE_MASTER_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(GRAPHITE_MASTER_DOCKER_DIR))
GRAPHITE_MASTER_IMAGE_NAME=nanit/$(GRAPHITE_MASTER_APP_NAME):$(GRAPHITE_MASTER_IMAGE_TAG)
GRAPHITE_MASTER_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_MASTER_APP_NAME)/replicas)

define generate-graphite-master-svc
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_MASTER_APP_NAME)/g' kube/$(GRAPHITE_MASTER_DIR_NAME)/svc.yml
endef

define generate-graphite-master-dep
	if [ -z "$(GRAPHITE_MASTER_REPLICAS)" ]; then echo "ERROR: GRAPHITE_MASTER_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_MASTER_APP_NAME)/g;s,{{IMAGE_NAME}},$(GRAPHITE_MASTER_IMAGE_NAME),g;s/{{REPLICAS}}/$(GRAPHITE_MASTER_REPLICAS)/g' kube/$(GRAPHITE_MASTER_DIR_NAME)/dep.yml
endef

deploy-graphite-master: docker-graphite-master
	kubectl get svc $(GRAPHITE_MASTER_APP_NAME) || $(call generate-graphite-master-svc) | kubectl create -f -
	$(call generate-graphite-master-dep) | kubectl apply -f -

docker-graphite-master:
	sudo docker pull $(GRAPHITE_MASTER_IMAGE_NAME) || (sudo docker build -t $(GRAPHITE_MASTER_IMAGE_NAME) $(GRAPHITE_MASTER_DOCKER_DIR) && sudo docker push $(GRAPHITE_MASTER_IMAGE_NAME))


deploy: deploy-statsd-proxy deploy-statsd-daemon deploy-carbon-relay deploy-graphite-node deploy-graphite-master
