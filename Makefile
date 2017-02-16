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



deploy: deploy-statsd-proxy deploy-statsd-daemon# deploy-carbon-relay deploy-graphite-node deploy-graphite-master
