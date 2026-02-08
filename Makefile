# Variables
SHELL := /bin/bash
APP_NAME := app-test
NAMESPACE := dev

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# --- Application ---
.PHONY: build run test clean image-load

build: ## Build the Docker image
	@echo "[INFO] Building Docker Image..."
	@chmod +x scripts/build_docker.sh
	@./scripts/build_docker.sh

run-local: ## Run the container locally (Docker only, no K8s)
	@chmod +x scripts/run_local.sh
	@./scripts/run_local.sh

test-local: ## Simple curl test against local Docker (Port 5000)
	@echo "[INFO] Testing local docker endpoints..."
	@curl -s http://localhost:5000/ | grep "message" && echo " [OK] Root Endpoint" || echo " [FAIL] Root Endpoint"
	@curl -s http://localhost:5000/health | grep "healthy" && echo " [OK] Health Endpoint" || echo " [FAIL] Health Endpoint"

clean: ## Remove local Docker artifacts and Helm release
	@echo "[INFO] Cleaning up..."
	@docker rm -f saas-app-container 2>/dev/null || true
	@helm uninstall $(APP_NAME) -n $(NAMESPACE) 2>/dev/null || true
	@echo "[INFO] Clean complete."

# --- Infrastructure & Kubernetes ---
.PHONY: setup tests tunnel curl cluster-start cluster-stop infra-init infra-plan infra-apply infra-destroy

setup: ## Full Setup: Start Cluster -> Infra -> Build -> Deploy
	@echo "\n[INFO] 🚀 Starting Full Setup..."
	@make cluster-start
	@make infra-init
	@make infra-apply
	@make build
	@make image-load
	@echo "[INFO] Deploying Helm Chart..."
	@helm upgrade --install $(APP_NAME) charts/saas-app/ --namespace $(NAMESPACE) --create-namespace
	@echo "[INFO] Waiting for Pods to be ready..."
	@kubectl wait --namespace $(NAMESPACE) --for=condition=ready pod -l app=$(APP_NAME) --timeout=60s
	@echo "\n[INFO] ✅ Environment setup complete! Run 'make tunnel' to access the app."

tests: ## Check Cluster Status
	@echo "[INFO] Checking Cluster State..."
	@kubectl get all -n $(NAMESPACE)
	@kubectl get pods -n $(NAMESPACE)

tunnel: ## Open Port-Forward (BLOCKING COMMAND)
	@echo "[INFO] Opening Tunnel to http://localhost:8080 (Ctrl+C to stop)..."
	@kubectl port-forward -n $(NAMESPACE) svc/$(APP_NAME) 8080:80

curl: ## Test App endpoints (Requires 'make tunnel' running in another terminal)
	@echo "[INFO] Testing K8s endpoints..."
	@curl -s http://localhost:8080/ | grep "message" && echo " [OK] Root" || echo " [FAIL] Root"
	@curl -s http://localhost:8080/health | grep "healthy" && echo " [OK] Health" || echo " [FAIL] Health"
	@curl -s http://localhost:8080/config

image-load: ## Load local image into Minikube
	@echo "[INFO] Loading image into Minikube (this may take a moment)..."
	@minikube image load saas-app:local
	@echo "[INFO] Image loaded."

cluster-start: ## Start Minikube if not running
	@minikube status >/dev/null 2>&1 || (echo "[INFO] Starting Minikube..." && minikube start --driver=docker --force)

cluster-stop: ## Stop Minikube
	@minikube stop
	@echo "[INFO] Cluster stopped."

infra-init: ## Initialize Terraform
	@echo "[INFO] Terraform Init..."
	@cd infra && terraform init

infra-plan: ## Plan Terraform changes
	@echo "[INFO] Terraform Plan..."
	@cd infra && terraform plan

infra-apply: ## Apply Terraform
	@echo "[INFO] Terraform Apply..."
	@cd infra && terraform apply -auto-approve

infra-destroy: ## Destroy infrastructure resources
	@echo "[WARNING] Destroying Infrastructure..."
	@cd infra && terraform destroy -auto-approve || echo "[WARN] Terraform destroy failed (maybe cluster is down?)"
	@minikube delete --all
	@echo "[INFO] Environment Destroyed."