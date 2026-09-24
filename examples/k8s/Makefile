# Makefile for BGP gateway simulation example
# Build svc image and deploy sim-gw services

DOCKER_BUILD_DIR = $(CURDIR)
CONTAINERD_SOCK = /run/k3s/containerd/containerd.sock

SVC_IMAGE_NAME = svc
SVC_IMAGE_VER = v1.0.0-beta.1
SVC_DOCKERFILE = $(CURDIR)/Dockerfile.svc

.DELETE_ON_ERROR: $(SVC_IMAGE_NAME)-$(SVC_IMAGE_VER).tar

# Build and import svc image into containerd
build-svc:
	sudo docker build -f $(SVC_DOCKERFILE) -t $(SVC_IMAGE_NAME):$(SVC_IMAGE_VER) $(DOCKER_BUILD_DIR) && \
	docker save $(SVC_IMAGE_NAME):$(SVC_IMAGE_VER) > $(SVC_IMAGE_NAME)-$(SVC_IMAGE_VER).tar && \
	sudo ctr --address $(CONTAINERD_SOCK) --namespace k8s.io images import $(SVC_IMAGE_NAME)-$(SVC_IMAGE_VER).tar && \
	rm $(SVC_IMAGE_NAME)-$(SVC_IMAGE_VER).tar

# Install network configuration
install:
	kubectl apply -f network.yaml

# Uninstall network configuration
uninstall:
	kubectl delete -f network.yaml --ignore-not-found

# Deploy sim-gw services (network + gateways)
deploy:
	kubectl apply -f sim-gw-a.yaml
	kubectl apply -f sim-gw-b.yaml

# Remove sim-gw services
undeploy:
	kubectl delete -f sim-gw-b.yaml --ignore-not-found
	kubectl delete -f sim-gw-a.yaml --ignore-not-found

# Remove svc image tag
rmi-svc-tag:
	sudo docker rmi $(SVC_IMAGE_NAME):$(SVC_IMAGE_VER)

.PHONY: build-svc install uninstall deploy undeploy rmi-svc-tag