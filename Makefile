all: test-run

DOCKER_BUILD_DIR = $(CURDIR)
CONTAINERD_SOCK = /run/k3s/containerd/containerd.sock

IMAGE_NAME = bgp
IMAGE_VER = v1.0.0-beta.1
DOCKERFILE_PATH = $(CURDIR)/Dockerfile

.DELETE_ON_ERROR: $(IMAGE_NAME)-$(IMAGE_VER).tar

test-run:
	echo "test"

build-img:
	sudo docker build -f $(DOCKERFILE_PATH) -t $(IMAGE_NAME):$(IMAGE_VER) $(DOCKER_BUILD_DIR) && \
	docker save $(IMAGE_NAME):$(IMAGE_VER) > $(IMAGE_NAME)-$(IMAGE_VER).tar && \
	sudo ctr --address $(CONTAINERD_SOCK) --namespace k8s.io images import $(IMAGE_NAME)-$(IMAGE_VER).tar && \
	rm $(IMAGE_NAME)-$(IMAGE_VER).tar

rmi-repo-tag:
	sudo docker rmi $(IMAGE_NAME):$(IMAGE_VER)

.PHONY: build-img rmi-repo-tag
