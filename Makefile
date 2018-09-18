DOCKER_REPOSITORY?=nanit
SUDO?=sudo

STATSD_PROXY_APP_NAME=statsd
STATSD_PROXY_DIR_NAME=statsd-proxy
STATSD_PROXY_DOCKER_DIR=docker/$(STATSD_PROXY_DIR_NAME)
STATSD_PROXY_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(STATSD_PROXY_DOCKER_DIR))
STATSD_PROXY_IMAGE_NAME=$(DOCKER_REPOSITORY)/$(STATSD_PROXY_APP_NAME):$(STATSD_PROXY_IMAGE_TAG)
STATSD_PROXY_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(STATSD_PROXY_APP_NAME)/replicas)
STATSD_PROXY_ADDITIONAL_YAML?=$(shell curl -s config/$(NANIT_ENV)/$(STATSD_PROXY_APP_NAME)/additional_yaml)

define generate-statsd-proxy-svc
	sed -e 's/{{APP_NAME}}/$(STATSD_PROXY_APP_NAME)/g' kube/$(STATSD_PROXY_DIR_NAME)/svc.yml
endef

define generate-statsd-proxy-dep
	if [ -z "$(STATSD_PROXY_REPLICAS)" ]; then echo "ERROR: STATSD_PROXY_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(STATSD_PROXY_APP_NAME)/g;s,{{IMAGE_NAME}},$(STATSD_PROXY_IMAGE_NAME),g;s/{{REPLICAS}}/$(STATSD_PROXY_REPLICAS)/g;s@{{ADDITIONAL_YAML}}@$(STATSD_PROXY_ADDITIONAL_YAML)@g' kube/$(STATSD_PROXY_DIR_NAME)/dep.yml
endef

deploy-statsd-proxy: docker-statsd-proxy
	kubectl get svc $(STATSD_PROXY_APP_NAME) || $(call generate-statsd-proxy-svc) | kubectl create -f -
	$(call generate-statsd-proxy-dep) | kubectl apply -f -

docker-statsd-proxy:
	$(SUDO) docker pull $(STATSD_PROXY_IMAGE_NAME) || ($(SUDO) docker build -t $(STATSD_PROXY_IMAGE_NAME) $(STATSD_PROXY_DOCKER_DIR) && $(SUDO) docker push $(STATSD_PROXY_IMAGE_NAME))

clean-statsd-proxy:
	kubectl delete deployment $(STATSD_PROXY_APP_NAME) || true

#-------------------------------------------------------------------------------------------------------------------------------------------------
STATSD_DAEMON_APP_NAME=statsd-daemon
STATSD_DAEMON_DIR_NAME=statsd-daemon
STATSD_DAEMON_DOCKER_DIR=docker/$(STATSD_DAEMON_DIR_NAME)
STATSD_DAEMON_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(STATSD_DAEMON_DOCKER_DIR))
STATSD_DAEMON_IMAGE_NAME=$(DOCKER_REPOSITORY)/$(STATSD_DAEMON_APP_NAME):$(STATSD_DAEMON_IMAGE_TAG)
STATSD_DAEMON_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(STATSD_DAEMON_APP_NAME)/replicas)
STATSD_DAEMON_ADDITIONAL_YAML?=$(shell curl -s config/$(NANIT_ENV)/$(STATSD_DAEMON_APP_NAME)/additional_yaml)

define generate-statsd-daemon-svc
	sed -e 's/{{APP_NAME}}/$(STATSD_DAEMON_APP_NAME)/g' kube/$(STATSD_DAEMON_DIR_NAME)/svc.yml
endef

define generate-statsd-daemon-dep
	if [ -z "$(STATSD_DAEMON_REPLICAS)" ]; then echo "ERROR: STATSD_DAEMON_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(STATSD_DAEMON_APP_NAME)/g;s,{{IMAGE_NAME}},$(STATSD_DAEMON_IMAGE_NAME),g;s/{{REPLICAS}}/$(STATSD_DAEMON_REPLICAS)/g;s@{{ADDITIONAL_YAML}}@$(STATSD_DAEMON_ADDITIONAL_YAML)@g' kube/$(STATSD_DAEMON_DIR_NAME)/dep.yml
endef

deploy-statsd-daemon: docker-statsd-daemon
	kubectl get svc $(STATSD_DAEMON_APP_NAME) || $(call generate-statsd-daemon-svc) | kubectl create -f -
	$(call generate-statsd-daemon-dep) | kubectl apply -f -

docker-statsd-daemon:
	$(SUDO) docker pull $(STATSD_DAEMON_IMAGE_NAME) || ($(SUDO) docker build -t $(STATSD_DAEMON_IMAGE_NAME) $(STATSD_DAEMON_DOCKER_DIR) && $(SUDO) docker push $(STATSD_DAEMON_IMAGE_NAME))

clean-statsd-daemon:
	kubectl delete deployment $(STATSD_DAEMON_APP_NAME) || true

#-------------------------------------------------------------------------------------------------------------------------------------------------
CARBON_RELAY_APP_NAME=carbon-relay
CARBON_RELAY_DIR_NAME=carbon-relay
CARBON_RELAY_DOCKER_DIR=docker/$(CARBON_RELAY_DIR_NAME)
CARBON_RELAY_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(CARBON_RELAY_DOCKER_DIR))
CARBON_RELAY_IMAGE_NAME=$(DOCKER_REPOSITORY)/$(CARBON_RELAY_APP_NAME):$(CARBON_RELAY_IMAGE_TAG)
CARBON_RELAY_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(CARBON_RELAY_APP_NAME)/replicas)
CARBON_RELAY_ADDITIONAL_YAML?=$(shell curl -s config/$(NANIT_ENV)/$(CARBON_RELAY_APP_NAME)/additional_yaml)

define generate-carbon-relay-svc
	sed -e 's/{{APP_NAME}}/$(CARBON_RELAY_APP_NAME)/g' kube/$(CARBON_RELAY_DIR_NAME)/svc.yml
endef

define generate-carbon-relay-dep
	if [ -z "$(CARBON_RELAY_REPLICAS)" ]; then echo "ERROR: CARBON_RELAY_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(CARBON_RELAY_APP_NAME)/g;s,{{IMAGE_NAME}},$(CARBON_RELAY_IMAGE_NAME),g;s/{{REPLICAS}}/$(CARBON_RELAY_REPLICAS)/g;s@{{ADDITIONAL_YAML}}@$(CARBON_RELAY_ADDITIONAL_YAML)@g' kube/$(CARBON_RELAY_DIR_NAME)/dep.yml
endef

deploy-carbon-relay: docker-carbon-relay
	kubectl get svc $(CARBON_RELAY_APP_NAME) || $(call generate-carbon-relay-svc) | kubectl create -f -
	$(call generate-carbon-relay-dep) | kubectl apply -f -

docker-carbon-relay:
	$(SUDO) docker pull $(CARBON_RELAY_IMAGE_NAME) || ($(SUDO) docker build -t $(CARBON_RELAY_IMAGE_NAME) $(CARBON_RELAY_DOCKER_DIR) && $(SUDO) docker push $(CARBON_RELAY_IMAGE_NAME))

clean-carbon-relay:
	kubectl delete deployment $(CARBON_RELAY_APP_NAME) || true
	kubectl delete svc $(CARBON_RELAY_APP_NAME) || true

#-------------------------------------------------------------------------------------------------------------------------------------------------
GRAPHITE_NODE_APP_NAME=graphite-node
GRAPHITE_NODE_DIR_NAME=graphite-node
GRAPHITE_NODE_DOCKER_DIR=docker/$(GRAPHITE_NODE_DIR_NAME)
GRAPHITE_NODE_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(GRAPHITE_NODE_DOCKER_DIR))
GRAPHITE_NODE_IMAGE_NAME=$(DOCKER_REPOSITORY)/$(GRAPHITE_NODE_APP_NAME):$(GRAPHITE_NODE_IMAGE_TAG)
GRAPHITE_NODE_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_NODE_APP_NAME)/replicas)
GRAPHITE_NODE_DISK_SIZE?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_NODE_APP_NAME)/disk_size)
GRAPHITE_NODE_CURATOR_RETENTION?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_NODE_APP_NAME)/curator_retention)
GRAPHITE_NODE_STORAGE_CLASS?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_NODE_APP_NAME)/storage_class)
GRAPHITE_NODE_ADDITIONAL_YAML?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_NODE_APP_NAME)/additional_yaml)

define generate-graphite-node-svc
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_NODE_APP_NAME)/g' kube/$(GRAPHITE_NODE_DIR_NAME)/svc.yml
endef

define generate-graphite-node-dep
	if [ -z "$(GRAPHITE_NODE_REPLICAS)" ]; then echo "ERROR: GRAPHITE_NODE_REPLICAS is empty!"; exit 1; fi
	if [ -z "$(GRAPHITE_NODE_DISK_SIZE)" ]; then echo "ERROR: GRAPHITE_NODE_DISK_SIZE is empty!"; exit 1; fi
	if [ -z "$(GRAPHITE_NODE_STORAGE_CLASS)" ]; then echo "ERROR: GRAPHITE_NODE_STORAGE_CLASS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_NODE_APP_NAME)/g;s,{{STORAGE_CLASS}},$(GRAPHITE_NODE_STORAGE_CLASS),g;s,{{IMAGE_NAME}},$(GRAPHITE_NODE_IMAGE_NAME),g;s/{{REPLICAS}}/$(GRAPHITE_NODE_REPLICAS)/g;s/{{CURATOR_RETENTION}}/$(GRAPHITE_NODE_CURATOR_RETENTION)/g;s/{{DISK_SIZE}}/$(GRAPHITE_NODE_DISK_SIZE)/g;s@{{ADDITIONAL_YAML}}@$(GRAPHITE_NODE_ADDITIONAL_YAML)@g' kube/$(GRAPHITE_NODE_DIR_NAME)/stateful.set.yml
endef

deploy-graphite-node: docker-graphite-node
	kubectl get svc $(GRAPHITE_NODE_APP_NAME) || $(call generate-graphite-node-svc) | kubectl create -f -
	$(call generate-graphite-node-dep) | kubectl apply -f -

docker-graphite-node:
	$(SUDO) docker pull $(GRAPHITE_NODE_IMAGE_NAME) || ($(SUDO) docker build -t $(GRAPHITE_NODE_IMAGE_NAME) $(GRAPHITE_NODE_DOCKER_DIR) && $(SUDO) docker push $(GRAPHITE_NODE_IMAGE_NAME))

clean-graphite-node:
	kubectl delete statefulset $(GRAPHITE_NODE_APP_NAME) || true
	kubectl delete pvc -l app=$(GRAPHITE_NODE_APP_NAME) || true

#-------------------------------------------------------------------------------------------------------------------------------------------------
GRAPHITE_MASTER_APP_NAME=graphite
GRAPHITE_MASTER_DIR_NAME=graphite-master
GRAPHITE_MASTER_DOCKER_DIR=docker/$(GRAPHITE_MASTER_DIR_NAME)
GRAPHITE_MASTER_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(GRAPHITE_MASTER_DOCKER_DIR))
GRAPHITE_MASTER_IMAGE_NAME=$(DOCKER_REPOSITORY)/$(GRAPHITE_MASTER_APP_NAME):$(GRAPHITE_MASTER_IMAGE_TAG)
GRAPHITE_MASTER_REPLICAS?=$(shell curl -s config/$(NANIT_ENV)/$(GRAPHITE_MASTER_APP_NAME)/replicas)

define generate-graphite-master-svc
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_MASTER_APP_NAME)/g' kube/$(GRAPHITE_MASTER_DIR_NAME)/svc.yml
endef

define generate-graphite-master-dep
	if [ -z "$(GRAPHITE_MASTER_REPLICAS)" ]; then echo "ERROR: GRAPHITE_MASTER_REPLICAS is empty!"; exit 1; fi
	sed -e 's/{{APP_NAME}}/$(GRAPHITE_MASTER_APP_NAME)/g;s,{{IMAGE_NAME}},$(GRAPHITE_MASTER_IMAGE_NAME),g;s/{{REPLICAS}}/$(GRAPHITE_MASTER_REPLICAS)/g' kube/$(GRAPHITE_MASTER_DIR_NAME)/dep.yml
endef

RBAC_DIR_NAME=rbac
RBAC_API_VERSION=$(shell (kubectl api-versions | grep rbac. | grep -sE v1$$) || (kubectl api-versions | grep rbac. | grep -sE v1beta1$$) || (kubectl api-versions | grep rbac. | grep -sE v1alpha1$$) || echo "")

define generate-rbac-role
	sed -e 's;{{RBAC_API_VERSION}};$(RBAC_API_VERSION);g' kube/$(RBAC_DIR_NAME)/role.yml
endef

define generate-rbac-rolebinding
	sed -e 's;{{RBAC_API_VERSION}};$(RBAC_API_VERSION);g' kube/$(RBAC_DIR_NAME)/role-binding.yml
endef

deploy-rbac:
	if [ -z "$(RBAC_API_VERSION)" ]; then exit 1; fi
	kubectl apply -f kube/rbac/serviceaccount.yml
	$(call generate-rbac-role) | kubectl apply -f -
	$(call generate-rbac-rolebinding) | kubectl apply -f -

clean-rbac:
	if [ -z "$(RBAC_API_VERSION)" ]; then exit 1; fi
	kubectl delete serviceaccount graphite-cluster-sa || true
	kubectl delete rolebinding read-endpoints || true
	kubectl delete role endpoints-reader || true

deploy-graphite-master: docker-graphite-master
	kubectl get svc $(GRAPHITE_MASTER_APP_NAME) || $(call generate-graphite-master-svc) | kubectl create -f -
	$(call generate-graphite-master-dep) | kubectl apply -f -

docker-graphite-master:
	$(SUDO) docker pull $(GRAPHITE_MASTER_IMAGE_NAME) || ($(SUDO) docker build -t $(GRAPHITE_MASTER_IMAGE_NAME) $(GRAPHITE_MASTER_DOCKER_DIR) && $(SUDO) docker push $(GRAPHITE_MASTER_IMAGE_NAME))

clean-graphite-master:
	kubectl delete deployment $(GRAPHITE_MASTER_APP_NAME) || true


deploy: deploy-rbac deploy-graphite-node deploy-statsd-daemon deploy-statsd-proxy deploy-carbon-relay deploy-graphite-master

clean: clean-statsd-proxy clean-statsd-daemon clean-carbon-relay clean-graphite-node clean-graphite-master clean-rbac

verify-statsd:
	kubectl exec $(name) -- cat proxyConfig.js | grep host

verify-carbon:
	kubectl exec $(name) -- cat /opt/graphite/conf/carbon.conf | grep DESTINATIONS

verify-graphite:
	kubectl exec $(name) -- cat /opt/graphite/webapp/graphite/local_settings.py | grep CLUSTER_SERVERS
