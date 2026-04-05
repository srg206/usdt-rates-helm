HELM_CHART := usdt-rates
APP_ROOT ?= ../usdt-rates
IMAGE ?= usdt-rates:latest

.PHONY: helm-deps helm-template k8s-docker-build

helm-deps:
	helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
	helm dependency update ./$(HELM_CHART)

helm-template: helm-deps
	helm template test ./$(HELM_CHART) --debug

k8s-docker-build:
	docker build -t $(IMAGE) -f $(APP_ROOT)/Dockerfile $(APP_ROOT)
