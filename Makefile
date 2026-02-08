# Variables
SHELL := /bin/bash

# --- Application ---
.PHONY: build run test clean

build: ## Build the Docker image
	@chmod +x scripts/build_docker.sh
	@./scripts/build_docker.sh

run: ## Run the container locally
	@chmod +x scripts/run_local.sh
	@./scripts/run_local.sh

test: ## Simple curl test
	@echo "[INFO] Testing endpoints..."
	@curl -s http://localhost:5000/ | grep "message" && echo " [OK] Root Endpoint"
	@curl -s http://localhost:5000/health | grep "healthy" && echo " [OK] Health Endpoint"

clean: ## Remove local containers
	@docker rm -f saas-app-container 2>/dev/null || true
	@docker rmi saas-app:local 2>/dev/null || true
	helm uninstall app-test -n dev
	@echo "[INFO] Cleaned up containers and images from Docker."

# --- Infrastructure (Terraform & Minikube) ---
.PHONY: cluster-start cluster-stop infra-init infra-plan infra-apply infra-destroy
	
setup: ## Setup environment
	@echo "[INFO] Setting up environment..."
	@make clean
	@make build
	@make cluster-start
	@make image-load
	@make infra-init
	@make infra-plan
	@make infra-apply
	helm lint charts/saas-app/
	helm install app-test charts/saas-app/ --namespace dev
	@echo "[INFO] Environment setup complete."
	
tests: ## Run tests
	@echo "[INFO] Running tests..."
	kubectl get all -A
	kubectl get pods -n dev
	kubectl port-forward -n dev svc/app-test 8080:80
	@echo "[INFO] Tests complete."
	
curl: ## Run curl commands
	curl -s http://localhost:8080/
	curl -s http://localhost:8080/health
	curl -s http://localhost:8080/config

image-load: ## Load local image into Minikube
	@echo "[INFO] Loading image into Minikube..."
	@minikube image load saas-app:local
	@echo "[INFO] Image loaded."	
	
cluster-start: ## Start Minikube if not running
	@if ! minikube status > /dev/null 2>&1; then \
		echo "[INFO] Starting Minikube Cluster..."; \
		minikube start --driver=docker --force; \
		echo "[INFO] Cluster is ready."; \
	else \
		echo "[INFO] Minikube is already running."; \
	fi

cluster-stop: ## Stop Minikube
	@minikube stop
	@echo "[INFO] Cluster stopped."

infra-init: cluster-start ## Initialize Terraform (Starts cluster first)
	@echo "[INFO] Initializing Terraform..."
	@cd infra && terraform init

infra-plan: cluster-start ## Plan Terraform changes
	@echo "[INFO] Planning Infrastructure..."
	@cd infra && terraform plan

infra-apply: cluster-start ## Apply Terraform (Starts cluster first)
	@echo "[INFO] Applying Infrastructure..."
	@cd infra && terraform apply -auto-approve

infra-destroy: ## Destroy infrastructure resources
	@cd infra && terraform destroy -auto-approve
	minikube delete --all

