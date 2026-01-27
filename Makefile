# Variables
SHELL := /bin/bash

# Targets
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
	@echo "[INFO] Cleaned up containers."