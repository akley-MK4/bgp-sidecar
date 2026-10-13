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

# Show IPv6 routes currently received via BGP on each sim-gw
show-routes:
	@echo "== sim-gw-a: IPv6 routes received from BGP neighbors =="
	kubectl exec deploy/sim-gw-a -c bgp -- vtysh -c "show bgp ipv6 unicast"
	kubectl exec deploy/sim-gw-a -c bgp -- bash -c "ip -6 route show table 1"
	kubectl exec deploy/sim-gw-a -c bgp -- bash -c "ip -6 rule show"
	@echo "\n"
	@echo "== sim-gw-b: IPv6 routes received from BGP neighbors =="
	kubectl exec deploy/sim-gw-b -c bgp -- vtysh -c "show bgp ipv6 unicast"
	kubectl exec deploy/sim-gw-b -c bgp -- bash -c "ip -6 route show table 1"
	kubectl exec deploy/sim-gw-b -c bgp -- bash -c "ip -6 rule show"

# Show the latest 100 log lines from all containers in each sim-gw pod
show-logs:
	@echo "== sim-gw-a: latest 100 log lines per container =="
	kubectl logs deploy/sim-gw-a --all-containers=true --tail=100 --prefix=true
	@echo "\n\n\n"
	@echo "== sim-gw-b: latest 100 log lines per container =="
	kubectl logs deploy/sim-gw-b --all-containers=true --tail=100 --prefix=true

.PHONY: build-svc install uninstall deploy undeploy rmi-svc-tag show-routes show-logs